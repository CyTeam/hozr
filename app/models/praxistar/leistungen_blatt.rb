class Praxistar::LeistungenBlatt < Praxistar::Base
  set_table_name "Leistungen_Blatt"
  set_primary_key "ID_Leistungsblatt"

  has_many :leistungen_daten, :foreign_key => 'Leistungsblatt_ID'

  def hozr_classification=(classification)
    for tarmed_leistung in classification.tarmed_leistungen
      leistung = Praxistar::LeistungenDaten.new
      leistung.tarmed_leistung = tarmed_leistung
      leistungen_daten<< leistung
    end
  end
end
