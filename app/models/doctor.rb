# encoding: utf-8

class Doctor < ActiveRecord::Base
  # Access restrictions
  attr_accessible :vcard, :ean_party, :zsr, :print_payment_for

  scope :active, where(:active => true)

  # TODO support multiple vcards
  has_vcards
  has_one :vcard, :as => :object
  accepts_nested_attributes_for :vcard
  attr_accessible :vcard_attributes

  belongs_to :billing_doctor, :class_name => 'Doctor'

  def billing_doctor_id
    read_attribute(:billing_doctor_id) || id
  end

  # Proxy accessors
  def name
    if vcard.nil?
      login
    else
      vcard.full_name
    end
  end

  # ZSR sanitation
  def zsr=(value)
    value.delete!(' .') unless value.nil?

    write_attribute(:zsr, value)
  end


  # Settings
  # ========
  has_settings
  def self.settings
    doctor = Doctor.find(Thread.current["doctor_id"]) if Doctor.exists?(Thread.current["doctor_id"])

    doctor.present? ? doctor.settings : Settings
  end

  has_many :cases
  has_many :patients
  has_many :mailings
  has_and_belongs_to_many :offices

  # CyLab
  # =====
  has_one :user, :as => :object, :autosave => true
  delegate :email, :email=, :to => :user

  # Office
  # ======
  has_and_belongs_to_many :offices
  # TODO:
  # This is kind of a primary office providing printers etc.
  # But it undermines the assumption that a doctor may belong/
  # own more than one office.
  def office
    offices.first
  end


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
  # =======
  def to_s
    [vcard.honorific_prefix, vcard.full_name].map(&:presence).compact.join(" ")
  end
end
