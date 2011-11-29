class Doctor < ActiveRecord::Base
  scope :active, where(:active => true)

  has_one :praxis, :class_name => 'Vcard', :as => :object, :conditions => {:vcard_type => 'praxis'}
  has_one :private, :class_name => 'Vcard', :as => :object, :conditions => {:vcard_type => 'private'}
  belongs_to :billing_doctor, :class_name => 'Doctor'
  
  has_many :cases
  has_many :patients
  has_many :mailings
  has_and_belongs_to_many :offices

  # CyLab
  # =====
  has_one :user, :as => :object, :autosave => true
  delegate :email, :email=, :to => :user

  has_and_belongs_to_many :offices

  # Multichannel
  # ============
  def channels
    channel = []
    channel << 'hl7' if wants_hl7
    channel << 'email' if wants_email
    channel << 'print' if wants_prints
    channel << 'overview_email' if wants_overview_email
    
    channel
  end
  
  # HL7
  scope :wanting_hl7, includes(:user).where("users.wants_hl7 = ?", true)
  delegate :wants_hl7, :wants_hl7=, :to => :user

  # Email
  scope :wanting_emails, includes(:user).where("users.wants_email = ?", true)
  delegate :wants_email, :wants_email=, :to => :user
  scope :wanting_overview_emails, includes(:user).where("users.wants_overview_email = ?", true)
  delegate :wants_overview_email, :wants_overview_email=, :to => :user

  # Printing
  scope :wanting_prints, includes(:user).where("users.wants_prints = ?", true)
  delegate :wants_prints, :wants_prints=, :to => :user
    
  # Helpers
  def to_s
    name
  end
  
  # Hozr
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
