class Tarmed::Leistung < Tarmed::Base
  set_table_name "LEISTUNG"
  set_primary_key "LNR"

  has_one :text, :class_name => 'LeistungText', :conditions => "SPRACHE = 'D' AND GUELTIG_BIS = '12/31/99 00:00:00'", :foreign_key => 'LNR'

  has_one :leistung_hierarchie_master, :class_name => 'LeistungHierarchie', :foreign_key => 'LNR_SLAVE'
  has_many :leistung_hierarchie_slaves, :class_name => 'LeistungHierarchie', :foreign_key => 'LNR_MASTER'
  
  def name
    text.BEZ_255
  end

  def duration
    self.LSTGIMES_MIN || 0
    # + self.VBNB_MIN + self.BEFUND_MIN + self.ZUSATZ_MIN + self.RAUM_MIN + self.WECHSEL_MIN
  end

  def master
    leistung_hierarchie_master.master unless leistung_hierarchie_master.nil?
  end

  def slaves
    leistung_hierarchie_slaves.collect { |slaves| slaves.slave }
  end
end
