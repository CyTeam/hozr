class Praxistar::Payment < Praxistar::Base
  set_table_name "Debitoren_Zahlungsjournal"
  set_primary_key "ID_Zahlungsjournal"

  belongs_to :patient, :foreign_key => "Patient_ID"
  belongs_to :bill, :foreign_key => "Rechnung_ID"
  belongs_to :account_receivable, :foreign_key => "Debitoren_ID"
end
