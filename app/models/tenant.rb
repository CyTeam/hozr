class Tenant < ActiveRecord::Base
  # Associations
  belongs_to :doctor, :foreign_key => :person_id
  has_many :users

  # Settings
  has_settings

  def to_s
    doctor.to_s
  end

  # Attachments
  # ===========
  has_many :attachments, :as => :object
  accepts_nested_attributes_for :attachments, :reject_if => proc { |attributes| attributes['file'].blank? }
end
