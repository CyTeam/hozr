# encoding: utf-8

class Patient < ActiveRecord::Base
  # Base data
  validates_presence_of :birth_date
  validates_presence_of :sex

  # Insurance
  has_many :insurance_policies, :autosave => true, :validate => true
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

  # Address
  has_one :vcard, :as => :object, :conditions => {:vcard_type => 'private'}
  accepts_nested_attributes_for :vcard
  has_one :billing_vcard, :class_name => 'Vcard', :as => :object, :conditions => {:vcard_type => 'billing'}
  accepts_nested_attributes_for :billing_vcard

  def invoice_vcard
    if use_billing_address?
      return billing_vcard
    else
      return vcard
    end
  end

  validate :validate_address
  def validate_address
    vcard.validate_name
    errors.add(:base, 'name invalid for vcard') if vcard.errors.present?

    invoice_vcard.validate_name
    errors.add(:base, 'name invalid for invoice_vcard') if invoice_vcard.errors.present?
    invoice_vcard.address.validate_address
    errors.add(:base, 'address invalid for invoice_vcard') if invoice_vcard.address.errors.present?
  end

  # Cases
  has_many :cases, :order => 'id DESC'
  has_many :finished_cases, :class_name => 'Case', :conditions => 'screened_at IS NOT NULL', :order => 'id DESC'
  
  # Invoices
  scope :dunning_stopped, where(:dunning_stop => true)

  # Sphinx Search
  # =============
  define_index do
    # Delta index
#    set_property :delta => true

    indexes birth_date

    indexes vcard.full_name
    indexes vcard.nickname
    indexes vcard.family_name
    indexes vcard.given_name
    indexes vcard.additional_name
    indexes vcard.address.street_address
    indexes vcard.address.postal_code
    indexes vcard.address.locality
    indexes vcard.address.extended_address
    indexes vcard.address.post_office_box

    indexes billing_vcard.full_name
    indexes billing_vcard.nickname
    indexes billing_vcard.family_name
    indexes billing_vcard.given_name
    indexes billing_vcard.additional_name
    indexes billing_vcard.address.street_address
    indexes billing_vcard.address.postal_code
    indexes billing_vcard.address.locality
    indexes billing_vcard.address.extended_address
    indexes billing_vcard.address.post_office_box

    indexes doctor_patient_nr

    indexes cases.praxistar_eingangsnr
  end

  def self.by_text(query, options = {})
    options.merge!({:match_mode => :extended})

    search(build_query(query), options)
  end

  def self.quote_query(query)
    "\"#{query}\""
  end

  def self.build_query_part(part)
    case part
    when /[0-9]{2}\/[0-9]{5}/
      quote_query(part)
    when /[0-9]{1,2}\.[0-9]{1,2}\.[0-9]{2,4}/
      day, month, year = part.split('.').map(&:to_i)
      if year < 100
        year1900 = quote_query(Date.new(1900 + year, month, day).to_s(:db))
        year2000 = quote_query(Date.new(2000 + year, month, day).to_s(:db))
        return "(#{year1900} | #{year2000})"
      else
        return quote_query(Date.new(year, month, day).to_s(:db))
      end
    else
      return part
    end
  end

  def self.build_query(query)
    return '' unless query.present?

    parts = query.split(/ /)

    parts.map{|part| build_query_part(part)}.join(' ')
  end

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
