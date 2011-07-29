class Praxistar::PatientenPersonalien < Praxistar::Base
  set_table_name "Patienten_Personalien"
  set_primary_key "ID_Patient"
  
  def self.hozr_model
    Patient
  end
  
  def self.export_attributes(hozr_record, new_record)
    result = {
        :tx_Ort => hozr_record.vcard.locality,
        :tx_TelefonP => hozr_record.vcard.phone_number,
        :tx_TelefonN => hozr_record.vcard.mobile_number,
        :tx_PLZ => hozr_record.vcard.postal_code,
        :tx_Strasse => hozr_record.vcard.street_address,
        :tx_Name => hozr_record.vcard.family_name,
        :tx_Vorname => hozr_record.vcard.given_name,
        :tx_Anrede => hozr_record.vcard.honorific_prefix,
        :tx_fakt_Ort => hozr_record.billing_vcard.locality,
        :tx_fakt_PLZ => hozr_record.billing_vcard.postal_code,
        :tx_fakt_ZuHanden => hozr_record.billing_vcard.extended_address,
        :tx_fakt_Strasse => hozr_record.billing_vcard.street_address,
        :tx_fakt_Name => hozr_record.billing_vcard.family_name,
        :tx_fakt_Vorname => hozr_record.billing_vcard.given_name,
        :tx_fakt_Anrede => hozr_record.billing_vcard.honorific_prefix,
        :KK_Garant_ID => hozr_record.insurance_id,
        :tx_KK_MitgliedNr => hozr_record.insurance_nr,
        :ZuwArzt_ID => hozr_record.doctor_id,
        :tx_Geburtsdatum => hozr_record.birth_date_db,
        :tx_Aufnahmedatum => hozr_record.created_at,
        :dt_Mutationsdatum => hozr_record.updated_at,
        :mo_Bemerkung => hozr_record.remarks,
        :Geschlecht_ID => hozr_record.sex,
        :tf_Mahnen => hozr_record.dunning_stop,
        :tf_fakt_Aktiv => hozr_record.use_billing_address,
        :tf_Exitus => hozr_record.deceased,
        
        # const attributes
        :Mandant_ID => 1
      }

      result[:ln_Patienten_Nr] = hozr_record.id + 200000 if new_record

      return result
  end
end
