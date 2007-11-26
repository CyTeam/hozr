class Mailing < ActiveRecord::Base
  belongs_to :doctor
  has_and_belongs_to_many :cases, :class_name => 'Cyto::Case', :order => 'classification_id'

  def self.create(doctor_id, case_ids)
    mailing = self.new
    mailing.doctor_id = doctor_id
    mailing.case_ids = case_ids
    mailing.save!
    
    puts mailing.id
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
