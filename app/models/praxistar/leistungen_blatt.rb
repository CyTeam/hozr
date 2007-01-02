class Praxistar::LeistungenBlatt < Praxistar::Base
  set_table_name "Leistungen_Blatt"
  set_primary_key "ID_Leistungsblatt"

  has_many :leistungen_daten, :foreign_key => 'Leistungsblatt_ID'
end
