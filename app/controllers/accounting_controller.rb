class AccountingController < ApplicationController
  def accounts_receivable
    @start_date = params[:start_date] || Date.new(Date.today.year, 1, 1)
    @end_date = params[:end_date] || Date.today

    @opening_saldo = 0
    @zuviel_bezahlt = 0
    
    @gestellte_rechnungen = Praxistar::AccountReceivable.sum('cu_rechnungsbetrag', :conditions => ["dt_rechnungsdatum BETWEEN ? AND ? AND dt_1Mahnung IS NULL", @start_date, @end_date]).to_f
    @stornierte_rechnungen = Praxistar::AccountReceivable.sum('cu_rechnungsbetrag', :conditions => ["dt_Stornodatum BETWEEN ? AND ? AND tf_storno = 1  AND dt_1Mahnung IS NULL", @start_date, @end_date]).to_f
    @gestellte_rechnungen += Praxistar::AccountReceivable.sum('cu_rechnungsbetrag + cu_mahnspesen1', :conditions => ["dt_rechnungsdatum BETWEEN ? AND ? AND dt_1Mahnung IS NOT NULL AND dt_2Mahnung IS NULL", @start_date, @end_date]).to_f
    @stornierte_rechnungen += Praxistar::AccountReceivable.sum('cu_rechnungsbetrag + cu_mahnspesen1', :conditions => ["dt_Stornodatum BETWEEN ? AND ? AND tf_storno = 1 AND dt_1Mahnung IS NOT NULL AND dt_2Mahnung IS NULL", @start_date, @end_date]).to_f
    @gestellte_rechnungen += Praxistar::AccountReceivable.sum('cu_rechnungsbetrag + cu_mahnspesen2', :conditions => ["dt_rechnungsdatum BETWEEN ? AND ? AND dt_2Mahnung IS NOT NULL AND dt_3Mahnung IS NULL", @start_date, @end_date]).to_f
    @stornierte_rechnungen += Praxistar::AccountReceivable.sum('cu_rechnungsbetrag + cu_mahnspesen2', :conditions => ["dt_Stornodatum BETWEEN ? AND ? AND tf_storno = 1 AND dt_2Mahnung IS NOT NULL AND dt_3Mahnung IS NULL", @start_date, @end_date]).to_f
    @gestellte_rechnungen += Praxistar::AccountReceivable.sum('cu_rechnungsbetrag + cu_mahnspesen3', :conditions => ["dt_rechnungsdatum BETWEEN ? AND ? AND dt_3Mahnung IS NOT NULL", @start_date, @end_date]).to_f
    @stornierte_rechnungen += Praxistar::AccountReceivable.sum('cu_rechnungsbetrag + cu_mahnspesen3', :conditions => ["dt_Stornodatum BETWEEN ? AND ? AND tf_storno = 1 AND dt_3Mahnung IS NOT NULL", @start_date, @end_date]).to_f

    @bezahlte_rechnungen = Praxistar::Payment.sum('cu_betrag', :conditions => ["dt_bezahldatum BETWEEN ? AND ?", @start_date, @end_date]).to_f
    @stornierte_zahlungen = Praxistar::Payment.sum('cu_betrag', :conditions => ["dt_Stornodatum BETWEEN ? AND ? AND tf_storno = 1", @start_date, @end_date]).to_f

    @debitoren_verluste = Praxistar::ReceivableWriteOff.sum('cu_differenz', :conditions => ["dt_verbucht = ?", @end_date]).to_f

    @closing_saldo = @opening_saldo - @zuviel_bezahlt + @gestellte_rechnungen - @stornierte_rechnungen - @bezahlte_rechnungen + @stornierte_zahlungen - @debitoren_verluste

    @total = @opening_saldo + @gestellte_rechnungen + @stornierte_zahlungen

    # Next two queries should return same amount
    # @total_billed = Praxistar::AccountReceivable.sum('cu_rechnungsbetrag', :conditions => ["dt_rechnungsdatum BETWEEN ? AND ? AND tf_storno = 0", @start_date, @end_date]).to_f
    @total_billed = Praxistar::Bill.sum('cu_total', :conditions => ["dt_rechnungsdatum BETWEEN ? AND ? AND tf_storno = 0", @start_date, @end_date]).to_f
    @total_canceled_bills = Praxistar::AccountReceivable.sum('cu_rechnungsbetrag', :conditions => ["dt_rechnungsdatum BETWEEN ? AND ? AND tf_storno != 0", @start_date, @end_date]).to_f

    @total_paid = Praxistar::Payment.sum('cu_betrag', :conditions => ["dt_bezahldatum BETWEEN ? AND ? AND tf_storno = 0", @start_date, @end_date]).to_f
    @total_canceled_payments = Praxistar::Payment.sum('cu_betrag', :conditions => ["dt_bezahldatum BETWEEN ? AND ? AND tf_storno != 0", @start_date, @end_date]).to_f

    @total_write_off = Praxistar::ReceivableWriteOff.sum('cu_differenz', :conditions => ["dt_verbucht BETWEEN ? AND ?", @start_date, @end_date]).to_f

    @opening_saldo = Praxistar::AccountReceivable.open(@start_date)
    @closing_saldo = Praxistar::AccountReceivable.open(@end_date)

  end
end
