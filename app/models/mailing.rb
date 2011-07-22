class Mailing < ActiveRecord::Base
  belongs_to :doctor
  has_and_belongs_to_many :cases, :include => {:classification => :classification_group}, :order => 'classification_groups.position DESC, praxistar_eingangsnr'

  # SendQueue
  has_many :send_queues, :order => 'send_queues.sent_at'
  named_scope :with_unsent_channel, :joins => :send_queues, :conditions => "sent_at IS NULL", :order => 'mailings.created_at'
  named_scope :without_channel, :include =>:send_queues, :conditions => 'send_queues.id IS NULL'

  after_save :create_hl7_email_channels
  
  def create_hl7_email_channels
    SendQueue.create(:mailing => self, :channel => "email", :sent_at => DateTime.now) if doctor.wants_email
    SendQueue.create(:mailing => self, :channel => "hl7", :sent_at => DateTime.now) if doctor.wants_hl7
  end

  def self.case_count_without_channel
    without_channel.inject(0) {|sum, mailing| sum += mailing.cases.count}
  end

  # String
  def to_s
    "%i Resultate für %s" % [cases.count, doctor]
  end

  def self.create(doctor_id, case_ids)
    mailing = self.new
    mailing.doctor_id = doctor_id
    mailing.case_ids = case_ids

    mailing.save!
    return mailing
  end

  def self.create_all_for_doctor(doctor_id)
    d = Doctor.find(doctor_id)
    mailing = nil
    
    if d.wants_prints
      # Check if there's an open mailing
      mailing = d.mailings.without_channel.first

      # Create a new one if not
      mailing = d.mailings.build if mailing.nil?

      # Clear in case it an existing mailing
      mailing.cases.clear
      # And add all unprinted cases to mailing
      mailing.cases = d.cases.find(:all, :conditions => ["screened_at IS NOT NULL AND needs_review = 0 AND result_report_printed_at IS NULL"], :order => :praxistar_eingangsnr)
    else
      # Create new mail if email wanted
      mailing = self.new
      mailing.doctor_id = doctor_id
      cases = Case.find(:all, :conditions => ["email_sent_at IS NULL AND screened_at IS NOT NULL AND needs_review = 0 AND doctor_id = ?", doctor_id], :order => :praxistar_eingangsnr)
      mailing.cases = cases
      cases.map{|c| c.email_sent_at = DateTime.now; c.save}
    end
    
    return if mailing.cases.empty?
    
    mailing.save!
    return mailing
  end

  def self.create_all
    lock_path = File.join(RAILS_ROOT, 'tmp', 'mailing_create_all.lock')
    # Exit if lock not available
    if File.exist?(lock_path)
      logger.info('Lock not available')
      return
    end
    
    # Lock available
    begin
      # Acquire lock
      lock = File.new(lock_path, "w")
      lock.close
      
      # TODO: Need to adapt for email
      doctor_ids = Case.find(:all, :select => 'DISTINCT doctor_id', :conditions => "( screened_at IS NOT NULL OR (screened_at IS NULL AND needs_p16 = 1) ) AND needs_review = 0 AND result_report_printed_at IS NULL")

      for doctor_id in doctor_ids
        self.create_all_for_doctor(doctor_id.doctor_id)
      end

    ensure
      # Release lock
      File.unlink(lock_path)
    end
  end

  # Email delivery
  # ==============
  def deliver_by_email
    done = 0
    failed = 0

    for a_case in cases
      begin
        a_case.deliver_report_by_email
        done += 1
      rescue
        #TODO do something sensible
        failed += 1
      end
    end

    return done, failed
  end

  # PDF
  def result_reports_to_pdf(page_size = 'A5')
    case page_size
    when 'A5':
      prawn_options = { :page_size => page_size, :top_margin => 60, :left_margin => 35, :right_margin => 35, :bottom_margin => 23 }
    when 'A4':
      prawn_options = { :page_size => page_size, :top_margin => 90, :left_margin => 40, :right_margin => 40, :bottom_margin => 40 }
    end

    pdf = ResultReport.new(prawn_options)
    
    return pdf.to_pdf(cases)
  end
  
  def print_result_reports(page_size, printer)
    # Workaround TransientJob not yet accepting options
    file = Tempfile.new('')
    file.puts(result_reports_to_pdf(page_size))
    file.close

    begin
      paper_copy = Cups::PrintJob.new(file.path, printer)
    rescue
      paper_copy = Cups::PrintJob.new(file.path, printer)
    end
    paper_copy.print

    # Mark cases as printed
    cases.map{|a_case| a_case.update_attribute(:result_report_printed_at, DateTime.now) }
  end
  
  def overview_to_pdf
    prawn_options = { :page_size => 'A4', :top_margin => 140, :left_margin => 60, :right_margin => 60, :bottom_margin => 100 }
    pdf = MailingOverview.new(prawn_options)
    
    return pdf.to_pdf(self)
  end
  
  def print_overview(printer)
    # Workaround TransientJob not yet accepting options
    file = Tempfile.new('')
    file.puts(overview_to_pdf)
    file.close

    begin
      paper_copy = Cups::PrintJob.new(file.path, printer)
    rescue
      paper_copy = Cups::PrintJob.new(file.path, printer)
    end
    paper_copy.print
  end

  def print(page_size, overview_printer, result_report_printer)
    print_overview(overview_printer)
    print_result_reports(page_size, result_report_printer)
  end
  
  # Multichannel
  # ============
  def send_by(channel)
    # Only generate new queue if there's no unsent present, yet
    return false unless send_queues.by_channel(channel).unsent.empty?
    
    SendQueue.create(:mailing => self, :channel => channel.to_s)
  end

  # Send on all undelivered channels
  def send_by_all_channels
    for channel in doctor.channels
      send_by(channel)
    end
  end
end
