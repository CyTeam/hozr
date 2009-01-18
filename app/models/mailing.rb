class Mailing < ActiveRecord::Base
  belongs_to :doctor
  has_and_belongs_to_many :cases, :class_name => 'Cyto::Case', :order => 'classification_id, praxistar_eingangsnr'

  def self.create(doctor_id, case_ids)
    mailing = self.new
    mailing.doctor_id = doctor_id
    mailing.case_ids = case_ids

    mailing.save!
    return mailing
  end

  def self.create_all_for_doctor(doctor_id)
    # Check if there's an open mailing
    mailing = Mailing.find(:first, :conditions => ['printed_at IS NULL AND doctor_id = ?', doctor_id])
    # Create a new one if not
    mailing = self.new if mailing.nil?
    mailing.doctor_id = doctor_id

    # Clear in case it an existing mailing
    mailing.cases.clear
    # And add all unprinted cases to mailing
    mailing.cases = Cyto::Case.find(:all, :conditions => ["( screened_at IS NOT NULL OR (screened_at IS NULL AND needs_p16 = 1) ) AND needs_review = 0 AND ((result_report_printed_at IS NULL AND p16_notice_printed_at IS NULL) OR (result_report_printed_at IS NULL AND p16_notice_printed_at IS NOT NULL AND screened_at IS NOT NULL)) AND doctor_id = ?", doctor_id], :order => :praxistar_eingangsnr)
    
    return if mailing.cases.empty?
    
    mailing.save!
    return mailing
  end

  def self.create_all
    doctor_ids = Cyto::Case.find(:all, :select => 'DISTINCT doctor_id', :conditions => "( screened_at IS NOT NULL OR (screened_at IS NULL AND needs_p16 = 1) ) AND needs_review = 0 AND result_report_printed_at IS NULL")

    for doctor_id in doctor_ids
      self.create_all_for_doctor(doctor_id.doctor_id)
    end
  end

  def reactivate
    cases.map { |c|
      c.result_report_printed_at = nil
      c.save
    }

    begin
      File.delete("public/mailing_overviews/mailing_overview-#{id}.ps")
      File.delete("public/mailing_overviews/mailing_overview-#{id}.pdf")
    rescue
      true
    end
  end
end
