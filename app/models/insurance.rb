class Insurance < ActiveRecord::Base
  belongs_to :vcard

  # Vcard
  def name
    vcard.full_name
  end

  def name=(name)
    create_vcard if vcard.nil?
    vcard.full_name = name
  end

  def post_office_box
    vcard.post_office_box
  end

  def post_office_box=(value)
    create_vcard if post_office_box.nil?
    vcard.post_office_box = value
  end

  def extended_vcard
    vcard.extended_vcard
  end

  def extended_vcard=(value)
    create_vcard if vcard.nil?
    vcard.extended_vcard = value
  end

  def street_vcard
    vcard.street_vcard
  end

  def street_address=(value)
    create_address if vcard.nil?
    vcard.street_address = value
  end

  def locality
    vcard.locality
  end

  def locality=(value)
    create_vcard  if vcard.nil?
    vcard.locality = value
  end

  def region
    vcard.region
  end

  def region=(value)
    create_vcard if vcard.nil?
    vcard.region = value
  end

  def postal_code
    vcard.postal_code
  end

  def postal_code=(value)
    create_vcard if vcard.nil?
    vcard.postal_code = value
  end

  def country_name
    vcard.country_name
  end

  def country_name=(value)
    create_vcard if vcard.nil?
    vcard.country_name = value
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


  def save
    vcard.save
    super
  end
end
