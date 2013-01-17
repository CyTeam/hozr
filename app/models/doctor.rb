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
  attr_accessible :user
  def email
    vcard.contacts.where(:phone_number_type => 'E-Mail').first
  end

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
  serialize :channels
  attr_accessible :channels

  def channels
    self[:channels].map(&:presence).compact
  end

  def wants?(channel)
    channels.include?(channel.to_s)
  end

  # Helpers
  # =======
  def to_s
    [vcard.honorific_prefix, vcard.full_name].map(&:presence).compact.join(" ")
  end
end
