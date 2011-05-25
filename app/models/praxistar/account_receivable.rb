class Praxistar::AccountReceivable < Praxistar::Base
  set_table_name "debitoren_debitoren"
  set_primary_key "id_debitoren"

  belongs_to :bill, :foreign_key => 'Rechnung_ID'
  has_one :payment, :foreign_key => 'Debitoren_ID'

  named_scope :open, lambda{|date|
    {
      :joins => "LEFT JOIN [Debitoren_Zahlungsjournal] ON Debitoren_Zahlungsjournal.Debitoren_ID = debitoren_debitoren.id_debitoren",
      :conditions => ["(dt_bezahldatum IS NULL OR dt_bezahldatum > :date) AND (debitoren_debitoren.dt_rechnungsdatum < :date) AND (debitoren_debitoren.dt_Stornodatum IS NULL OR debitoren_debitoren.dt_Stornodatum > :date) AND (debitoren_debitoren.modus_id = 9 OR debitoren_debitoren.modus_id = 6) AND (debitoren_debitoren.Mandant_ID = 1)", {:date => date}],
      :order => "id_debitoren"
    }
  }
  named_scope :saldo, lambda{
    {
      :select => "sum(cu_rechnungsbetrag) as 'Rechnungsbetrag', sum(cu_betrag) as 'Zahlbetrag', sum(cu_mahnspesen1) as 'Mahnspesen1', sum(cu_mahnspesen2) as 'Mahnspesen2', sum(cu_mahnspesen3) as 'Mahnspesen3'"
    }
  }
  
  def to_s
    "%s: %s (gemahnt %s, %s, %s) (stroniert %s) (bezahlt %s) CHF %0.2f" % [self.Rechnung_ID, self.dt_Rechnungsdatum, self.dt_1Mahnung, self.dt_2Mahnung, self.dt_3Mahnung, self.dt_Stornodatum, self.payment ? self.payment.dt_Bezahldatum : '', self.cu_rechnungsbetrag]
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
