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

  def extended_address
    vcard.extended_address
  end

  def extended_address=(value)
    create_vcard if vcard.nil?
    vcard.extended_address = value
  end

  def street_address
    vcard.street_address
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
    create_vcard if vcard.nil?
    vcard.phone_number = value
  end

  def phone_number
    vcard.phone_number
  end

  def fax_number=(value)
    create_vcard if vcard.nil?
    vcard.fax_number = value
  end

  def fax_number
    vcard.fax_number
  end


  def save
    vcard.save
    super
  end
end
