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
    
  def to_s
    "%s: #%s(%s) CHF %0.2f" % [patient.to_s(:short), id, payment_state, cu_TOTAL]
  end
  
  belongs_to :cyto_case, :class_name => 'Case', :foreign_key => 'Leistungsblatt_ID', :primary_key => 'praxistar_leistungsblatt_id'

  # State
  def payment_state
    return "unknown" if account_receivable.nil?
    return "cancelled" if account_receivable[:tf_Storno]
    return "payed" unless payments.select { |payment| payment.dt_Bezahldatum }.empty?

    if account_receivable[:dt_Betreibung]
      return "prosecured"
    elsif account_receivable[:dt_1Mahnung]
      return "reminded"
    end
  end

  scope :open,
    joins("LEFT JOIN [Debitoren_Zahlungsjournal] ON Debitoren_Zahlungsjournal.Rechnung_ID = ID_Rechnung LEFT JOIN [debitoren_debitoren] ON debitoren_debitoren.Rechnung_ID = ID_Rechnung").
    where("dt_Bezahldatum IS NULL AND debitoren_debitoren.tf_Storno = ?", false)

  # TODO: get rid of since constant as soon as db got cleaned up
  def open?
    since = Date.new(2009, 1, 1)
    !(payment_state == "payed" or payment_state == "cancelled") and dt_Rechnungsdatum >= since
  end
  
  def canceable?
    !(payment_state == "payed" or payment_state == "cancelled")
  end
  
  # Actions
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

  # Set treatment reason
  def treatment_reason=(reason)
    case reason
    when 'Krankheit':
      self.tf_Spez1 = true
      self.tf_Spez4 = false
      self.tf_Spez8 = false
    when 'Mutterschaft':
      self.tf_Spez1 = false
      self.tf_Spez4 = true
      self.tf_Spez8 = false
    when 'Vorsorge':
      self.tf_Spez1 = false
      self.tf_Spez4 = false
      self.tf_Spez8 = true
    end
    
    return self
  end

  def treatment_reason
    if self.tf_Spez1?
      return 'Krankheit'
    elsif self.tf_Spez4?
      return 'Mutterschaft'
    elsif self.tf_Spez8?
      return 'Vorsorge'
    end
  end
end
