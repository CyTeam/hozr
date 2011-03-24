class ClassificationTarmedLeistungen < ActiveRecord::Base
  belongs_to :classification
  belongs_to :tarmed_leistung, :class_name => 'Tarmed::Leistung', :foreign_key => 'tarmed_leistung_id'
  belongs_to :parent, :class_name => 'Tarmed::Leistung', :foreign_key => 'parent_id'
  
  def LNR
    tarmed_leistung.LNR
  end

  def name
    tarmed_leistung.name
  end
end
