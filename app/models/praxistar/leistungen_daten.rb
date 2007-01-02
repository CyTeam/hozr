class Praxistar::LeistungenDaten < Praxistar::Base
  set_table_name "Leistungen_Daten"
  
  def tarmed_leistung=(leistung)
    self.tx_Tarifcode = leistung.LNR
    self.tx_Fakturatext = leistung.name
    self.sg_Taxpunkte_TL = leistung.TP_TL
    self.sg_Taxpunkte = leistung.TP_AL
  end

  def tx_Tarifcode=(value)
    self.tx_Code1 = value.delete('.')
    write_attribute(:tx_Tarifcode, value)
  end
end
