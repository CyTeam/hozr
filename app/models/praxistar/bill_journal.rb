class Praxistar::BillJournal < Praxistar::Base
  set_table_name "Faktura_Journal"
  set_primary_key "Rechnung_ID"
  
  belongs_to :bill, :foreign_key => 'ID_Rechnung'
  belongs_to :patient, :foreign_key => 'Patient_ID'
  belongs_to :praxistar_leistungsblatt, :class_name => 'Praxistar::LeistungenBlatt', :foreign_key => 'Leistungsblatt_ID'
  belongs_to :cyto_case, :class_name => 'Case', :foreign_key => 'Leistungsblatt_ID', :primary_key => 'praxistar_leistungsblatt_id'
end
