class Patient < ActiveRecord::Base
  belongs_to :insurance
  belongs_to :doctor
  belongs_to :vcard
  belongs_to :billing_vcard, :class_name => 'Vcard', :foreign_key => 'billing_vcard_id'

  has_many :cases

  def name
    vcard.full_name
  end
end
