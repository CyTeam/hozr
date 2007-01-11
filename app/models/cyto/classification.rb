include Cyto

class Cyto::Classification < ActiveRecord::Base
  has_many :classification_tarmed_leistungen, :order => 'position'
  has_many :tarmed_leistungen, :class_name => 'ClassificationTarmedLeistungen', :order => 'position'
  belongs_to :examination_method
  has_and_belongs_to_many :top_finding_classes, :join_table => 'top_finding_classes', :class_name => 'FindingClass', :foreign_key => 'classification_id'
end
