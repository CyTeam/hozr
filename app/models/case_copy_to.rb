class CaseCopyTo < ActiveRecord::Base
  belongs_to :case
  attr_accessible :case_id

  belongs_to :person
  attr_accessible :person_id

  serialize :channels
  attr_accessible :channels
end
