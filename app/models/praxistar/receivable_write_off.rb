class Praxistar::ReceivableWriteOff < Praxistar::Base
  set_table_name "Debitoren_Debitorenverluste"
  set_primary_key "ID_Debitorenverlust"
  
  belongs_to :account_receivable, :class_name => 'Praxistar::AccountReceivable', :foreign_key => 'ID_Debitoren'
end
