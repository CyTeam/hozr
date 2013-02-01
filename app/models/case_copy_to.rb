class CaseCopyTo < ActiveRecord::Base
  belongs_to :case
  attr_accessible :case_id

  belongs_to :person
  accepts_nested_attributes_for :person
  attr_accessible :person_id, :person_attributes

  serialize :channels
  attr_accessible :channels
end
