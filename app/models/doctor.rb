class Doctor < ActiveRecord::Base
  belongs_to :vcard
  belongs_to :praxis, :class_name => 'Vcard', :foreign_key => 'praxis_vcard'
  belongs_to :private, :class_name => 'Vcard', :foreign_key => 'private_vcard'
  
  has_many :cases, :class_name => 'Cyto::Case'
  has_many :patients
  has_many :mailings
  has_and_belongs_to_many :offices

  
  def family_name
    praxis.family_name || ""
  end

  def family_name=(name)
    praxis.family_name = name
  end

  def given_name
    praxis.given_name || ""
  end

  def given_name=(name)
    praxis.given_name = name
  end

  def name
    praxis.full_name || ""
  end

  def billing_doctor_id
    read_attribute(:billing_doctor_id) || id
  end

  # Customers support
  def uid
    name.tr(' -', '_').underscore
  end

  def uidNumber
    sprintf("%03.0f", id)
  end

  # Password
  def password=(value)
    write_attribute(:password, Digest::SHA256.hexdigest(value))
  end
end
