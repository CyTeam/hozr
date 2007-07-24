class Praxistar::AccountReceivable < Praxistar::Base
  set_table_name "Debitoren_Debitoren"
  set_primary_key "id_debitoren"

  belongs_to :bill, :foreign_key => 'Rechnung_ID'
end
