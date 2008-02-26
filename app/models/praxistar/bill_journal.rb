class Praxistar::BillJournal < Praxistar::Base
  set_table_name "Faktura_Journal"
  set_primary_key "Rechnung_ID"
  
  belongs_to :bill, :foreign_key => 'ID_Rechnung'
  belongs_to :patient, :foreign_key => 'Patient_ID'
  belongs_to :praxistar_leistungsblatt, :class_name => 'Praxistar::LeistungenBlatt', :foreign_key => 'Leistungsblatt_ID'

  def cyto_case
    Cyto::Case.find(:first, :conditions => ['praxistar_leistungsblatt_id = ?', self[:Leistungsblatt_ID]])
  end
end
