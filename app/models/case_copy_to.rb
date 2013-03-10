class CaseCopyTo < ActiveRecord::Base
  belongs_to :case
  attr_accessible :case_id

  belongs_to :person
  accepts_nested_attributes_for :person, :reject_if => proc { |attributes| attributes['vcard_attributes']['full_name'].blank? }
  attr_accessible :person_id, :person_attributes

  serialize :channels
  attr_accessible :channels

  scope :by_channel, lambda {|channel| select{ |record| record.channels.include?(channel.to_s)} }
end
