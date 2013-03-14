# encoding: utf-8

class Doctor < Person
  # Access restrictions
  attr_accessible :vcard

  scope :active, where(:active => true)

  # Helpers
  # =======
  def to_s(format = :default)
    case format
    when :select
      [vcard.full_name].join(", ") + " (#{vcard.locality})"
    else
      [vcard.honorific_prefix, vcard.full_name].map(&:presence).compact.join(" ")
    end
  end

  # Proxy accessors
  def name
    vcard.try(:full_name)
  end

  # ZSR and EAN
  attr_accessible :ean_party, :zsr
  # ZSR sanitation
  def zsr=(value)
    value.delete!(' .') unless value.nil?

    write_attribute(:zsr, value)
  end

  has_many :patients

  # User
  has_one :user, :as => :object, :autosave => true
  attr_accessible :user
  def email
    vcard.contacts.where(:phone_number_type => 'E-Mail').first
  end

  # Hozr
  # ====
  has_many :cases
  has_many :mailings

  # Multichannel
  serialize :channels
  attr_accessible :channels

  def channels
    return [] if self[:channels].nil?

    self[:channels].map(&:presence).compact
  end

  def wants?(channel)
    channels.include?(channel.to_s)
  end
end
