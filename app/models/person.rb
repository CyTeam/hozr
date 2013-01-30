class Person < ActiveRecord::Base
  # Active
  attr_accessible :active

  # Validations
  validates_date :date_of_birth, :date_of_death, :allow_nil => true, :allow_blank => true
  validates_presence_of :vcard

  # sex enumeration
  MALE   = 1
  FEMALE = 2
  def sex_to_s(format = :default)
    case sex
    when MALE
      "M"
    when FEMALE
      "F"
    end
  end

  # String
  def to_s(format = :default)
    return unless vcard

    s = vcard.full_name

    case format
      when :long
        s += " (#{vcard.locality})" if vcard.locality
    end

    return s
  end

  # VCards
  # ======
  has_many :vcards, :as => :object
  has_one :vcard, :as => :object
  accepts_nested_attributes_for :vcard
  attr_accessible :vcard, :vcard_attributes

  def vcard_with_autobuild
    vcard_without_autobuild || build_vcard
  end
  alias_method_chain :vcard, :autobuild

  attr_accessible :code
  def code
    vcard.nickname || vcard.abbreviated_name
  end

  def code=(value)
    vcard.nickname = value
  end

  # Search
  default_scope includes(:vcard).order('IFNULL(vcards.full_name, vcards.family_name + ' ' + vcards.given_name)')

  # Attachments
  # ===========
  has_many :attachments, :as => :object
  accepts_nested_attributes_for :attachments, :reject_if => proc { |attributes| attributes['file'].blank? }

  # Others
  # ======
  belongs_to :civil_status
  belongs_to :religion
end
