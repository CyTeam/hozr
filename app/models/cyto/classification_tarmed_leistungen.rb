class Cyto::ClassificationTarmedLeistungen < ActiveRecord::Base
  belongs_to :classification
  belongs_to :tarmed_leistung, :class_name => 'Tarmed::Leistung', :foreign_key => 'tarmed_leistung_id'
end
