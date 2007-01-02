class Tarmed::Leistung < Tarmed::Base
  set_table_name "LEISTUNG"
  set_primary_key "LNR"

  has_one :text, :class_name => 'LeistungText', :conditions => "SPRACHE = 'D' AND GUELTIG_BIS = '12/31/99 00:00:00'", :foreign_key => 'LNR'

  def name
    text.BEZ_255
  end
end
