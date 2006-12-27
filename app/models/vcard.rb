class Vcard < ActiveRecord::Base
  has_one :address
  has_many :phone_numbers

  def full_name
    if super
      return super
    else
      return family_name + ", " + given_name
    end
  end

  def post_office_box
    address.post_office_box
  end

  def post_office_box=(value)
    address ||= create_address
    address.post_office_box = value
  end

  def extended_address
    address.extended_address
  end

  def extended_address=(value)
    if address.nil?
      create_address
    end
    address.extended_address = value
  end

  def street_address
    address.street_address
  end

  def street_address=(value)
    if address.nil?
      create_address
    end
    address.street_address = value
  end

  def locality
    address.locality
  end

  def locality=(value)
    if address.nil?
      create_address
    end
    address.locality = value
  end

  def region
    address.region
  end

  def region=(value)
    if address.nil?
      create_address
    end
    address.region = value
  end

  def postal_code
    address.postal_code
  end

  def postal_code=(value)
    if address.nil?
      create_address
    end
    address.postal_code = value
  end

  def country_name
    address.country_name
  end

  def country_name=(value)
    if address.nil?
      create_address
    end
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
