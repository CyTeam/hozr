# encoding: utf-8

class Classification < ActiveRecord::Base
  belongs_to :examination_method
  belongs_to :classification_group
  has_and_belongs_to_many :top_finding_classes, :join_table => 'top_finding_classes', :class_name => 'FindingClass', :foreign_key => 'classification_id'
end
