class Praxistar::Bill < Praxistar::Base
  set_table_name "Rechnungen_Blatt"
  set_primary_key "ID_Rechnung"

  belongs_to :patient, :foreign_key => 'Patient_ID'
  belongs_to :insurance, :foreign_key => 'Versicherung_ID'
  belongs_to :doctor, :foreign_key => 'Stellvertretung_ID'
  
  def cyto_case
    Cyto::Case.find(:first, :conditions => ['praxistar_leistungsblatt_id = ?', self[:Leistungsblatt_ID]])
  end
end
