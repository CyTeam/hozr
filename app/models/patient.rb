include Cyto
include Praxistar

class Patient < ActiveRecord::Base
  belongs_to :insurance
  belongs_to :doctor
  belongs_to :vcard
  belongs_to :billing_vcard, :class_name => 'Vcard', :foreign_key => 'billing_vcard_id'

  has_many :cases, :class_name => 'Cyto::Case', :order => 'id DESC'
  has_many :finished_cases, :class_name => 'Cyto::Case', :conditions => 'screened_at IS NOT NULL', :order => 'id DESC'
  has_many :bills, :class_name => 'Praxistar::Bill', :foreign_key => 'Patient_ID', :order => 'ID_Rechnung'
  has_many :praxistar_leistungsblaetter, :class_name => 'Praxistar::LeistungenBlatt'
  
  validates_presence_of :birth_date
  
  #TODO: differs from CyLab version as birth_date is overloaded
  def to_s
    "#{name} ##{doctor_patient_nr}, #{birth_date}"
  end

  # Attributes
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
    (doctor_patient_nr.nil? or doctor_patient_nr.strip.empty?) ? (" " * 5) : doctor_patient_nr
  end
  
  def in_place_doctor_patient_nr=(value)
    write_attribute(:doctor_patient_nr, value)
  end

  def in_place_insurance_nr
    (insurance_nr.nil? or insurance_nr.strip.empty?) ? (" " * 5) : insurance_nr
  end
  
  def in_place_insurance_nr=(value)
    write_attribute(:insurance_nr, value)
  end

  def delete_leistungsblaetter
    for l in praxistar_leistungsblaetter
      a_case = l.cyto_case
      if a_case
        a_case.praxistar_leistungsblatt_id = nil
        a_case.save
      end
      l.destroy
    end
  end
end
