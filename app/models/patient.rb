include Praxistar

class Patient < ActiveRecord::Base
  belongs_to :insurance
  belongs_to :doctor
  belongs_to :vcard
  belongs_to :billing_vcard, :class_name => 'Vcard', :foreign_key => 'billing_vcard_id'

  has_many :cases, :order => 'id DESC'
  has_many :finished_cases, :class_name => 'Case', :conditions => 'screened_at IS NOT NULL', :order => 'id DESC'
  has_many :bills, :class_name => 'Praxistar::Bill', :foreign_key => 'Patient_ID', :order => 'ID_Rechnung'
  has_one :praxistar_patienten_personalien, :class_name => 'Praxistar::PatientenPersonalien', :foreign_key => 'ID_Patient'
  has_many :praxistar_leistungsblaetter, :class_name => 'Praxistar::LeistungenBlatt'
  
  validates_presence_of :birth_date
  
  scope :dunning_stopped, where(:dunning_stop => true)

  # Search
  scope :search, lambda {|params|
    values = {}
    params.map{|key, value|
      if value.match(/bis|-/)
        values[key] = value.split(/bis|-/)[0].strip..value.split(/bis|-/)[1].strip
      else
        values[key] = value.strip
      end
    }
    patients = scoped
    patients = patients.where(:doctor_patient_nr => values[:doctor_patient_nr].strip) if values[:doctor_patient_nr].present?
    patients = patients.where(:birth_date => Date.parse_date(values[:birth_date], 1900)) if values[:birth_date].present?
    
    patients
  }
    
  #TODO: differs from CyLab version as birth_date is overloaded
  def to_s(format = :default)
    case format
      when :short
        name
      else
        "#{name} ##{doctor_patient_nr}, #{birth_date}"
    end
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

  def open_invoices
    bills.open
  end
  
  def reactivate_open_invoices
    open_invoices.map{|invoice| invoice.reactivate("Adressänderung")}
  end
end
