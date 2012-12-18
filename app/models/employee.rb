# encoding: utf-8

class Employee < ActiveRecord::Base
  belongs_to :work_vcard, :class_name => 'Vcard', :foreign_key => :work_vcard_id
  belongs_to :private_vcard, :class_name => 'Vcard', :foreign_key => :private_vcard_id

  # Proxies
  has_one :vcard, :as => :object
  accepts_nested_attributes_for :vcard
  attr_accessible :vcard, :vcard_attributes

  def name
    (work_vcard || private_vcard).try(:full_name)
  end

  def to_s
    self.name
  end
end
