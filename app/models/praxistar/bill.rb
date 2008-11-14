class Praxistar::Bill < Praxistar::Base
  set_table_name "Rechnungen_Blatt"
  set_primary_key "ID_Rechnung"

  belongs_to :patient, :foreign_key => 'Patient_ID'
  belongs_to :insurance, :foreign_key => 'Versicherung_ID'
  belongs_to :doctor, :foreign_key => 'Stellvertretung_ID'
  belongs_to :praxistar_leistungsblatt, :class_name => 'Praxistar::LeistungenBlatt', :foreign_key => 'Leistungsblatt_ID'
  
  has_one :account_receivable, :foreign_key => 'Rechnung_ID'
  has_one :bill_journal, :foreign_key => 'Rechnung_ID'
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

  def canceable?
    !(payment_state == "payed" or payment_state == "cancelled")
  end
  
  def cancel(reason = "Storniert")
#    raise "Kann bezahlte Rechnungen nicht stornieren!" if payment_state == "payed"
    account_receivable[:tf_Storno] = true
    account_receivable["tx_Storno_Begründung"] = reason
    account_receivable[:tf_aktiv] = false
    account_receivable[:dt_Stornodatum] = Date.today
    account_receivable.save!

    bill_journal[:tf_Storniert] = true
    bill_journal.save!
        
    self[:tf_Storno] = true
    save
  end

  def reactivate(reason = "Reaktiviert")
    cancel(reason)
    a_case = cyto_case
    a_case.praxistar_leistungsblatt_id = nil
    a_case.save!

    # Export patient data, in case it changed
    Praxistar::PatientenPersonalien.export(a_case.patient.id)

    a_case.praxistar_create_leistungsblatt
  end


  def self.batch_reactivate(ids, reason = nil)
    bills = self.find(ids.to_a)
    bills.map {|bill|
      begin
        bill.reactivate(reason)
        puts "Bill #{bill.id}: OK"
      rescue
        puts "Bill #{bill.id}: FAILED"
        puts "  #{$!}: FAILED"
      end
    }
  end
  
  def bill_type
    account_receivable.bill_type
  end
end
