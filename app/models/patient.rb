class Patient < ActiveRecord::Base
  belongs_to :insurance
  belongs_to :doctor
  belongs_to :vcard
  belongs_to :billing_vcard, :class_name => 'Vcard', :foreign_key => 'billing_vcard_id'

  has_many :cases
  has_many :finished_cases, :class_name => 'Cyto::Case', :conditions => 'screened_at IS NOT NULL'
  
  def name
    vcard.full_name unless vcard.nil?
  end
end
