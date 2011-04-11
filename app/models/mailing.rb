class Mailing < ActiveRecord::Base
  belongs_to :doctor
  has_and_belongs_to_many :cases, :order => 'classification_id, praxistar_eingangsnr'

  # SendQueue
  has_many :send_queues, :order => 'send_queues.sent_at'
  named_scope :with_unsent_channel, :joins => :send_queues, :conditions => "sent_at IS NULL", :order => 'mailings.created_at'
  named_scope :unsent, :conditions => "printed_at IS NULL AND email_delivered_at IS NULL AND hl7_delivered_at IS NULL"
  
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
      mailing = Mailing.find(:first, :conditions => ['printed_at IS NULL AND doctor_id = ?', doctor_id])
      # Create a new one if not
      mailing = self.new if mailing.nil?
      mailing.doctor_id = doctor_id

      # Clear in case it an existing mailing
      mailing.cases.clear
      # And add all unprinted cases to mailing
      mailing.cases = Case.find(:all, :conditions => ["( screened_at IS NOT NULL OR (screened_at IS NULL AND needs_p16 = 1) ) AND needs_review = 0 AND ((result_report_printed_at IS NULL AND p16_notice_printed_at IS NULL) OR (result_report_printed_at IS NULL AND p16_notice_printed_at IS NOT NULL AND screened_at IS NOT NULL)) AND doctor_id = ?", doctor_id], :order => :praxistar_eingangsnr)
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
