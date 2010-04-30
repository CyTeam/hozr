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
    return "unknown" if account_receivable.nil?
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

  # Fix for ambiguous handling of position 37.0620
  # ==============================================
  def self.fix_picky_insurance_cases(ids, insurance_id = 5)
    self.find(ids).map{|bill| bill.fix_picky_insurance_case(insurance_id)}
  end

  def fix_picky_insurance_case(insurance_id = 5)
    a_case = cyto_case
    puts "Patient #{patient.name}, Rechnung #{id}:"

    if a_case.insurance_id == insurance_id
      puts "Versicherung ok"
    elsif a_case.insurance_id.nil?
      puts "Setze Versicherung"
      a_case.insurance_id = insurance_id
      a_case.save
    else
      puts "WARN: Versicherung geändert von #{a_case.insurance.name}!"
      a_case.insurance_id = insurance_id
      a_case.save
    end

    patient = a_case.patient
    patient.remarks += "#{Date.today.strftime('%d.%m.%Y')}: Position 37.0620 gelöscht\n"
    patient.save

    reactivate("Position 37.0620 gelöscht")
  end

  def self.fix_all_picky_insurance_payments
    bills = Praxistar::AccountReceivable.find(:all, :conditions => "tx_Storno_Begründung = 'Position 37.0620 gelöscht'").map{|ar| ar.bill if ar.payment }.compact
    bills.map {|b| b.fix_picky_insurance_payment}
  end

  def fix_picky_insurance_payment
    puts "Patient #{patient.name}, Rechnung #{id}:"
    
    old = account_receivable
    puts "  ##{old.Rechnung_ID} à #{old.cu_rechnungsbetrag}"
    new = patient.cases.first.bill.account_receivable
    puts "  ##{new.Rechnung_ID} à #{new.cu_rechnungsbetrag}"
    payment = payments.first
    
    payment.Debitoren_ID = new.id
    payment.Leistungsblatt_ID = new.Leistungsblatt_ID
    payment.Rechnung_ID = new.Rechnung_ID
    payment.save

    patient = payment.patient
    patient.remarks += "#{Date.today.strftime('%d.%m.%Y')}: Zahlung auf Rechnung ohne Position 37.0620 umgebucht\nRückerstattung von CHF 5.40 fällig\n"
    patient.save
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
