class Praxistar::Bill < Praxistar::Base
  set_table_name "Rechnungen_Blatt"
  set_primary_key "ID_Rechnung"

  belongs_to :patient, :foreign_key => 'Patient_ID'
  belongs_to :insurance, :foreign_key => 'Versicherung_ID'
  belongs_to :doctor, :foreign_key => 'Stellvertretung_ID'
  belongs_to :praxistar_leistungsblatt, :class_name => 'Praxistar::LeistungenBlatt', :foreign_key => 'Leistungsblatt_ID'
  
  has_one :account_receivable, :foreign_key => 'Rechnung_ID'
  has_many :payments, :foreign_key => 'Rechnung_ID'
    
  def cyto_case
    Cyto::Case.find(:first, :conditions => ['praxistar_leistungsblatt_id = ?', self[:Leistungsblatt_ID]])
  end

  def payment_state
    return "cancelled" if account_receivable[:tf_Storno]
    return "payed" unless payments.select { |payment| payment.dt_Bezahldatum }.empty?

    if account_receivable[:dt_Betreibung]
      return "prosecured"
    elsif account_receivable[:dt_1Mahnung]
      return "reminded"
    end
  end

  def cancel(reason = "Storniert")
    raise "Kann bezahlte Rechnungen nicht stornieren!" if payment_state == "payed"
    account_receivable[:tf_Storno] = true
    account_receivable["tx_Storno_Begründung"] = reason
    account_receivable[:tf_aktiv] = false
    account_receivable[:dt_Stornodatum] = Date.today
    account_receivable.save
    
    self[:tf_Storno] = true
    save
  end

  def reactivate(reason = "Reaktiviert")
    cancel(reason)
    a_case = cyto_case
    a_case.praxistar_leistungsblatt_id = nil
    a_case.save
  end
end
