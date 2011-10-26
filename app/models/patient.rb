include Praxistar

class Patient < ActiveRecord::Base
  # Insurance
  has_many :insurance_policies, :autosave => true
  accepts_nested_attributes_for :insurance_policies, :reject_if => proc { |attrs| attrs['insurance_id'].blank? }
  has_many :insurances, :through => :insurance_policies

  def kvg_insurance_policy
    policy = insurance_policies.by_policy_type('KVG').first

    if policy.nil?
      policy = insurance_policies.build(:policy_type => 'KVG')
    end

    return policy
  end

  def insurance
    kvg_insurance_policy.insurance
  end
  def insurance=(value)
    kvg_insurance_policy.insurance = value
    kvg_insurance_policy.save
  end

  def insurance_id
    kvg_insurance_policy.insurance_id
  end
  def insurance_id=(value)
    kvg_insurance_policy.insurance_id = value
    kvg_insurance_policy.save
  end

  def insurance_nr
    kvg_insurance_policy.number
  end
  def insurance_nr=(value)
    kvg_insurance_policy.number = value
    kvg_insurance_policy.save
  end

  # Doctor
  belongs_to :doctor

  has_one :vcard, :as => :object, :conditions => {:vcard_type => 'private'}
  has_one :billing_vcard, :class_name => 'Vcard', :as => :object, :conditions => {:vcard_type => 'billing'}

  has_many :cases, :order => 'id DESC'
  has_many :finished_cases, :class_name => 'Case', :conditions => 'screened_at IS NOT NULL', :order => 'id DESC'
  
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
end
