# encoding: utf-8

class FindingGroup < ActiveRecord::Base
  has_many :finding_classes
end
