class AccountingController < ApplicationController
  def accounts_receivable
    @opening_saldo = 134110.4

    @gestellte_rechnungen = Praxistar::AccountReceivable.sum('cu_rechnungsbetrag', :conditions => "dt_rechnungsdatum BETWEEN '2007-01-01' AND '2007-12-31'").to_f
    @stornierte_rechnungen = Praxistar::AccountReceivable.sum('cu_rechnungsbetrag', :conditions => "dt_Stornodatum BETWEEN '2007-01-01' AND '2007-12-31' AND tf_storno = 1").to_f

    @bezahlte_rechnungen = Praxistar::Payment.sum('cu_betrag', :conditions => "dt_bezahldatum BETWEEN '2007-01-01' AND '2007-12-31'").to_f
    @stornierte_zahlungen = Praxistar::Payment.sum('cu_betrag', :conditions => "dt_Stornodatum BETWEEN '2007-01-01' AND '2007-12-31' AND tf_storno = 1").to_f

    @debitoren_verluste = Praxistar::ReceivableWriteOff.sum('cu_differenz', :conditions => "dt_verbucht = '2007-12-31'").to_f

    @closing_saldo = @opening_saldo + @gestellte_rechnungen - @stornierte_rechnungen - @bezahlte_rechnungen + @stornierte_zahlungen - @debitoren_verluste
  end
end
