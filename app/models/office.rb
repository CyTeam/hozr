# encoding: utf-8

class Office < ActiveRecord::Base
  has_and_belongs_to_many :doctors

  serialize :printers
end
