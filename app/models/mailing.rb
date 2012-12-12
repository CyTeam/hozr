# encoding: utf-8

class Mailing < ActiveRecord::Base
  belongs_to :doctor
  has_and_belongs_to_many :cases, :include => {:classification => :classification_group}, :order => 'classification_groups.position DESC, praxistar_eingangsnr'

  # SendQueue
  has_many :send_queues, :order => 'send_queues.sent_at'
  scope :with_unsent_channel, joins(:send_queues).where(:sent_at => nil).order('mailings.created_at')
  scope :without_channel, includes(:send_queues).where('send_queues.id IS NULL')
  def self.by_state(state)
    case state.to_s
    when 'unsent'
      without_channel
    else
      scoped
    end
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

    # Check if there's an open mailing
    mailing = d.mailings.without_channel.first

    # Create a new one if not
    mailing = d.mailings.build if mailing.nil?

    # Clear in case it an existing mailing
    mailing.cases.clear
    # And add all undelivered cases to mailing
    mailing.cases = d.cases.for_delivery.order(:praxistar_eingangsnr).all

    return if mailing.cases.empty?

    mailing.save!
    return mailing
  end

  def self.create_all
    lock_path = Rails.root.join('tmp', 'mailing_create_all.lock')
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
      doctor_ids = Case.select('DISTINCT doctor_id').for_delivery.all

      for doctor_id in doctor_ids
        self.create_all_for_doctor(doctor_id.doctor_id)
      end

    ensure
      # Release lock
      File.unlink(lock_path)
    end
  end

  # PDF
  def result_reports_to_pdf(page_size = 'A5')
    case page_size
    when 'A5'
      prawn_options = { :page_size => page_size, :top_margin => 60, :left_margin => 35, :right_margin => 35, :bottom_margin => 23 }
    when 'A4'
      prawn_options = { :page_size => page_size, :top_margin => 90, :left_margin => 40, :right_margin => 40, :bottom_margin => 40 }
    end

    pdf = ResultReport.new(prawn_options)

    return pdf.to_pdf(cases)
  end

  def print_result_reports(page_size, printer)
    # Workaround TransientJob not yet accepting options
    file = Tempfile.new('')
    file.binmode
    file.puts(result_reports_to_pdf(page_size))
    file.close

    printer.print_file(file.path)
  end

  def overview_to_pdf
    prawn_options = { :page_size => 'A4', :top_margin => 140, :left_margin => 60, :right_margin => 60, :bottom_margin => 100 }
    pdf = MailingOverview.new(prawn_options)

    return pdf.to_pdf(self)
  end

  def print_overview(printer)
    # Workaround TransientJob not yet accepting options
    file = Tempfile.new('')
    file.binmode
    file.puts(overview_to_pdf)
    file.close

    printer.print_file(file.path)
  end

  def print(page_size, overview_printer, result_report_printer)
    print_overview(overview_printer)
    print_result_reports(page_size, result_report_printer)
  end

  # Multichannel
  # ============
  def send_by(channel)
    # Only generate new queue if there's no unsent present, yet
    return nil unless send_queues.by_channel(channel).unsent.empty?

    SendQueue.create(:mailing => self, :channel => channel.to_s)
  end

  # Send on all undelivered channels
  def send_by_all_channels
    # Mark cases as delivered
    cases.map{|a_case| a_case.update_attribute(:delivered_at, DateTime.now) }

    for channel in doctor.channels
      send_by(channel)
    end
  end
end
