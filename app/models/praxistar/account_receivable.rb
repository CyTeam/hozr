class Praxistar::AccountReceivable < Praxistar::Base
  set_table_name "debitoren_debitoren"
  set_primary_key "id_debitoren"

  belongs_to :bill, :foreign_key => 'Rechnung_ID'
  has_one :payment, :foreign_key => 'Debitoren_ID'

  scope :valid, lambda {|date|
    where("debitoren_debitoren.dt_Stornodatum IS NULL OR debitoren_debitoren.dt_Stornodatum > :date", {:date => date})
  }

  scope :cancelled, lambda {|start_date, end_date|
    where("debitoren_debitoren.dt_Stornodatum BETWEEN :start_date AND :end_date", {:start_date => start_date, :end_date => end_date})
  }

  scope :open, lambda {|date|
   joins("LEFT OUTER JOIN [Debitoren_Zahlungsjournal] ON Debitoren_Zahlungsjournal.Debitoren_ID = debitoren_debitoren.id_debitoren").
     where("(dt_bezahldatum IS NULL OR dt_bezahldatum > :date) AND (debitoren_debitoren.dt_rechnungsdatum <= :date) AND (debitoren_debitoren.dt_Stornodatum IS NULL OR debitoren_debitoren.dt_Stornodatum > :date) AND (debitoren_debitoren.modus_id = 9 OR debitoren_debitoren.modus_id = 6) AND (debitoren_debitoren.Mandant_ID = 1)", {:date => date}).
     order("id_debitoren")
  }
  
  def to_s
    "%s: %s CHF %0.2f" % [self.bill.patient, self.dt_Rechnungsdatum.strftime('%d.%m.%Y'), self.cu_rechnungsbetrag]
#    "%s: %s (gemahnt %s, %s, %s) (stroniert %s) (bezahlt %s) CHF %0.2f" % [self.Rechnung_ID, self.dt_Rechnungsdatum, self.dt_1Mahnung, self.dt_2Mahnung, self.dt_3Mahnung, self.dt_Stornodatum, self.payment ? self.payment.dt_Bezahldatum : '', self.cu_rechnungsbetrag]
  end
  
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
