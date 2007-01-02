class Cyto::Classification < ActiveRecord::Base
  has_many :classification_tarmed_leistungen
  has_many :tarmed_leistungen, :class_name => 'Tarmed::Leistung'

  def tarmed_leistungen
    classification_tarmed_leistungen.collect { |l| l.tarmed_leistung }
  end
end
