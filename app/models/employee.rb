# encoding: utf-8

class Employee < ActiveRecord::Base
  # Access restrictions
  attr_accessible :code, :born_on, :workload

  # TODO support multiple vcards
  has_vcards
  has_one :vcard, :as => :object
  accepts_nested_attributes_for :vcard
  attr_accessible :vcard, :vcard_attributes

  def name
    vcard.try(:full_name)
  end

  def to_s
    self.name
  end
end
