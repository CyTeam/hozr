class Vcard < ActiveRecord::Base
  has_one :address
  has_many :phone_numbers

  has_one :patient

  def full_name
    result = read_attribute(:full_name)
    result ||= [ given_name, family_name ].compact.join(' ')
    
    return result
  end

  def abbreviated_name
    "#{given_name[0..0]}. #{family_name}"
  end
  
  def post_office_box
    address.post_office_box
  end

  def post_office_box=(value)
    create_address if post_office_box.nil?
    address.post_office_box = value
  end

  def extended_address
    address.extended_address
  end

  def extended_address=(value)
    create_address if address.nil?
    address.extended_address = value
  end

  def street_address
    address.street_address
  end

  def street_address=(value)
    create_address if address.nil?
    address.street_address = value
  end

  def locality
    address.locality
  end

  def locality=(value)
    create_address  if address.nil?
    address.locality = value
  end

  def region
    address.region
  end

  def region=(value)
    create_address if address.nil?
    address.region = value
  end

  def postal_code
    address.postal_code
  end

  def postal_code=(value)
    create_address if address.nil?
    address.postal_code = value
  end

  def country_name
    address.country_name
  end

  def country_name=(value)
    create_address if address.nil?
    address.country_name = value
  end

  def phone_number=(value)
    phone_numbers.build(:number => value, :phone_number_type => 'phone')
  end

  def phone_number
    begin
      numbers = phone_numbers.find(:all, :conditions => "phone_number_type = 'phone'")
      numbers.collect { |phone_number|
         phone_number.number if phone_number.number.strip != ''
      }.compact.join(", ")
    rescue
      return ''
    end
  end

  def mobile_number
    begin
      numbers = phone_numbers.find(:all, :condition => "phone_number_type = 'mobile'")
      numbers.collect { |phone_number|
         phone_number.number if phone_number.number.strip != ''
      }.compact.join(", ")
    rescue
      return ''
    end
  end
    
  def mobile_number=(value)
    phone_numbers.build(:number => value, :phone_number_type => 'mobile')
  end

  def fax_number=(value)
    phone_numbers.build(:number => value, :phone_number_type => 'fax')
  end

  def fax_number
    begin
      numbers = phone_numbers.find(:all, :conditions => "phone_number_type = 'fax'")
      numbers.collect { |phone_number|
         phone_number.number if phone_number.number.strip != ''
      }.compact.join(", ")
    rescue
      return ''
    end
  end

  def salutation
    case honorific_prefix
    when 'Herr Dr. med.'
      result = "Sehr geehrter Herr Dr. " + family_name
    when 'Frau Dr. med.'
      result = "Sehr geehrte Frau Dr. " + family_name
    when 'Herr Dr.'
      result = "Sehr geehrter Herr Dr. " + family_name
    when 'Frau Dr.'
      result = "Sehr geehrte Frau Dr. " + family_name
    when 'Herr'
      result = "Sehr geehrter Herr " + family_name
    when 'Frau'
      result = "Sehr geehrte Frau " + family_name
    when 'Br.'
      result = "Sehr geehrter Bruder " + family_name
    when 'Sr.'
      result = "Sehr geehrte Schwester " + family_name
    else
      result = "Sehr geehrte Damen und Herren"
    end
    return result
  end
end
