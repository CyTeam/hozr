class Praxistar::AccountReceivable < Praxistar::Base
  set_table_name "Debitoren_Debitoren"
  set_primary_key "id_debitoren"

  belongs_to :bill, :foreign_key => 'Rechnung_ID'
  has_one :payment, :foreign_key => 'Debitoren_ID'

  def bill_type
    if dt_betreibung
      return "Betreibung"
    elsif dt_3Mahnung
      return "3. Mahnung"
    elsif dt_2Mahnung
      return "2. Mahnung"
    elsif dt_1Mahnung
      return "1. Mahnung"
    end
    return "Rechnung"
  end
end
