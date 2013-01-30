# encoding: utf-8

class Doctor < Person
  # Access restrictions
  attr_accessible :vcard, :ean_party, :zsr

  scope :active, where(:active => true)

  # Proxy accessors
  def name
    vcard.try(:full_name)
  end

  # ZSR sanitation
  def zsr=(value)
    value.delete!(' .') unless value.nil?

    write_attribute(:zsr, value)
  end

  has_many :cases
  has_many :patients
  has_many :mailings

  # CyLab
  # =====
  has_one :user, :as => :object, :autosave => true
  attr_accessible :user
  def email
    vcard.contacts.where(:phone_number_type => 'E-Mail').first
  end

  # Multichannel
  # ============
  serialize :channels
  attr_accessible :channels

  def channels
    return [] if self[:channels].nil?

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
