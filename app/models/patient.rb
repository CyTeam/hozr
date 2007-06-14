include Cyto
include Praxistar

class Patient < ActiveRecord::Base
  belongs_to :insurance
  belongs_to :doctor
  belongs_to :vcard
  belongs_to :billing_vcard, :class_name => 'Vcard', :foreign_key => 'billing_vcard_id'

  has_many :cases, :order => 'praxistar_eingangsnr DESC'
  has_many :finished_cases, :class_name => 'Cyto::Case', :conditions => 'screened_at IS NOT NULL', :order => 'praxistar_eingangsnr DESC'

  has_many :payments
  has_many :bills, :foreign_key => 'Patient_ID'
  
  validates_presence_of :birth_date
  
  def name
    vcard.full_name unless vcard.nil?
  end

  def birth_date=(value)
    if value.is_a?(String)
      day, month, year = value.split('.')
      month ||= Date.today.month
      year ||= Date.today.year
      year = 1900 + year.to_i if year.to_i < 100
      
      write_attribute(:birth_date, "#{year}-#{month}-#{day}")
    else
      write_attribute(:birth_date, value)
    end
  end

  def birth_date_before_type_cast
    read_attribute(:birth_date).strftime("%d.%m.%Y") unless read_attribute(:birth_date).nil?
  end

  def birth_date
    read_attribute(:birth_date).strftime("%d.%m.%Y") unless read_attribute(:birth_date).nil?
  end

  def birth_date_db
    read_attribute(:birth_date)
  end

  def in_place_doctor_patient_nr
    (doctor_patient_nr.nil? or doctor_patient_nr.strip.empty?) ? ("&nbsp" * 5) : doctor_patient_nr
  end
  
  def in_place_doctor_patient_nr=(value)
    write_attribute(:doctor_patient_nr, value)
  end

  def in_place_insurance_nr
    (insurance_nr.nil? or insurance_nr.strip.empty?) ? ("&nbsp" * 5) : insurance_nr
  end
  
  def in_place_insurance_nr=(value)
    write_attribute(:insurance_nr, value)
  end
end
