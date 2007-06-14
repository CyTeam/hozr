class BillsController < ApplicationController
  def index
    redirect_to :action => 'search_form'
  end

  def search
    patient_id = params[:bill][:rechnung_id]

    @bills = Praxistar::PatientenPersonalien.connection.select_all("SELECT DISTINCT patienten_personalien.id_patient, debitoren_debitoren.rechnung_id, tx_name, tx_vorname, tx_strasse, tx_plz, tx_ort, tx_Geburtsdatum AS geburtsdatum, dt_eingang AS eingang, LTRIM(in_EingangJahr) + '/' + LTRIM(in_EingangsNr) AS eingangs_nr, CAST(mo_bemerkung as nvarchar(1024)) as bemerkung, CONVERT(decimal(10,2), cu_rechnungsbetrag) AS rechnungsbetrag, dt_Rechnungsdatum AS rechnungsdatum, dt_1mahnung AS mahnung1, dt_2mahnung AS mahnung2, dt_3mahnung AS mahnung3, dt_betreibung AS betreibung, dt_bezahldatum AS zahlung, debitoren_debitoren.dt_stornodatum AS stornierung, debitoren_debitoren.tx_storno_begründung AS storno_grund FROM debitoren_debitoren LEFT JOIN debitoren_zahlungsjournal ON debitoren_zahlungsjournal.leistungsblatt_id = debitoren_debitoren.leistungsblatt_id LEFT JOIN praxilab_daten ON praxilab_daten.leistungsblatt_id = debitoren_debitoren.leistungsblatt_id LEFT JOIN patienten_personalien ON patienten_personalien.ln_patienten_nr = debitoren_debitoren.ln_patienten_nr WHERE patienten_personalien.id_patient = #{patient_id} ORDER BY debitoren_debitoren.rechnung_id")
    render :partial => 'list'
  end
end
