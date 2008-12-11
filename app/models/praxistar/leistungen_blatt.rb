class Praxistar::LeistungenBlatt < Praxistar::Base
  set_table_name "Leistungen_Blatt"
  set_primary_key "ID_Leistungsblatt"

  has_many :leistungen_daten, :foreign_key => 'Leistungsblatt_ID'
  has_one :cyto_case, :class_name => 'Cyto::Case', :foreign_key => 'praxistar_leistungsblatt_id'

  def hozr_case=(a_case)
    i = 1
    total = 0

    tarmed_leistungen = a_case.classification.tarmed_leistungen
    # Don't add position 37.0620 for some insurances
    picky_insurances = [5] # ['Visana']
    if picky_insurances.include?(a_case.insurance_id)
      tarmed_leistungen.delete_if{|l| l.tarmed_leistung_id == '37.0620'}
    end

    for tarmed_leistung in tarmed_leistungen
      leistung = Praxistar::LeistungenDaten.new
      leistung.tarmed_leistung = tarmed_leistung
      leistung.dt_Erfassungsdatum = a_case.examination_date
      leistung.in_Leistungsnummer = i
      leistung.Leistungserbringer_ID = 1
      leistung.tx_Leistungserbringer = "ZytoLabor (Hozr)"
      leistung.tx_Leistungserfasser = "Admin"
      leistung.in_Reihenfolge = 1
      leistung.sg_Anzahl = 1
      leistung.Abrechnungsart_ID = 1
      leistung.tf_Medikament = 0
      leistung.cu_Taxpunktwert = 0.89
      leistung.Subtotal_ID = 9
      leistung.Kostenstelle_ID = 0
      leistung.MwstCode_ID = 0
      leistung.tf_MwstPflicht = 0
      leistung.tf_Fehler = 0
      leistung.tf_Nichtpflichtleistung = 0
      leistung.cu_Taxpunktwert_TL = 0.89
      leistung.sg_Session = 1
      leistung.tx_Tarifnummer = '001'
      leistung.tf_Check = 0
      
      leistung.cu_Preis = (leistung.sg_Taxpunkte * leistung.cu_Taxpunktwert) + (leistung.sg_Taxpunkte_TL * leistung.cu_Taxpunktwert_TL)
      leistung.cu_Total = leistung.sg_Anzahl * leistung.cu_Preis
      total += leistung.cu_Total
      
      leistungen_daten<< leistung
    
      i += 1
    end
    
    self.Patient_ID = a_case.patient_id
    self.Mandant_ID = 1
    self.Modus_ID = 9
    self.Versicherung_ID = a_case.insurance_id
    self.tx_Patient_VersicherungsNr = a_case.insurance_nr
    self.Bank_ID = 1
    self.in_Verrechnungssatz = 100
    self.in_Ratenintervall = 30
    self.tf_Spitaleinweisung = 0
    self.tf_Behandlungsende = 0
    self.tf_Kostenvoranschlag = 0
    self.tf_Edifact = 0
    self.dt_BehandlungVon = a_case.examination_date
    self.dt_BehandlungBis = a_case.examination_date
    self.cu_Totalbetrag = (total * 20.0).round / 20.0
#    self.tx_Stellvertretung = 
    
    self.in_Schuldner = a_case.patient.use_billing_address ? 2 : 1
    vcard = a_case.patient.use_billing_address ? a_case.patient.billing_vcard : a_case.patient.vcard
    self.tx_Schuldner_Anrede = vcard.honorific_prefix
    self.tx_Schuldner_Name = vcard.family_name
    self.tx_Schuldner_Vorname = vcard.given_name
    self.tx_Schuldner_Strasse = vcard.street_address
    self.tx_Schuldner_zH = vcard.extended_address
    self.tx_Schuldner_PLZ = vcard.postal_code
    self.tx_Schuldner_Ort = vcard.locality
    self.tf_Spez1 = 1
    self.tf_Spez2 = 0
    self.tf_Spez3 = 0
    self.tf_Spez4 = 0
    self.tf_Spez5 = 0
    self.tf_Spez6 = 0
    self.tf_Spez7 = 0
    self.tf_Spez8 = 0
    self.tf_Spez9 = 0
    self.tf_Spez10 = 0
    self.tf_Nichtpflichtleistungen = 0
    self.tf_Test = 0
    self.tf_gesperrt = 0
    self.in_Behandlungsende = 1
    self.Stellvertretung_ID = a_case.doctor.billing_doctor_id
  end
  
  def total_amount
  end
  
  def hozr_classification=(classification)
  end
end
