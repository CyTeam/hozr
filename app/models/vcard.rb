class Vcard < ActiveRecord::Base
  has_one :address
  has_many :phone_numbers

  def full_name
    result = read_attribute(:full_name)
    result ||= [ family_name, given_name ].compact.join(', ')
    
    return result
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
    phone_numbers.build(:number => value, :phone_number_type => 'business')
  end

  def phone_number
    begin
      phone_numbers[0].number
    rescue
      return ''
    end
  end

  def fax_number=(value)
    phone_numbers.build(:number => value, :phone_number_type => 'fax')
  end

  def fax_number
    begin
      fax_numbers[0].number
    rescue
      return ''
    end
  end
end
