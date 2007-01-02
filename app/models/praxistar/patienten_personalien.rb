class Praxistar::PatientenPersonalien < Praxistar::Base
  set_table_name "Patienten_Personalien"
  set_primary_key "ID_Patient"
  
  def self.hozr_model
    Patient
  end
  
  def self.import
    Patient.delete_all
    
    for a in find(:all)
      begin
        p = Patient.new(
          :vcard => Vcard.new(
            :locality => a.tx_Ort,
            :phone_number => a.tx_TelefonP,
            :mobile_number => a.tx_TelefonN,
            :postal_code => a.tx_PLZ,
            :street_address => a.tx_Strasse,
            :family_name => a.tx_Name,
            :given_name => a.tx_Vorname,
            :honorific_prefix => [a.tx_Anrede, a.tx_Titel].join(' ')
          ),
          :billing_vcard => Vcard.new(
            :locality => a.tx_fakt_Ort,
            :postal_code => a.tx_fakt_PLZ,
            :street_address => a.tx_fakt_Strasse,
            :family_name => a.tx_fakt_Name,
            :given_name => a.tx_fakt_Vorname,
            :extended_address => a.tx_fakt_ZuHanden,
            :honorific_prefix => [a.tx_fakt_Anrede, a.tx_fakt_Titel].join('')
          ),
          :insurance_id => a.KK_Garant_ID,
          :insurance_nr => a.tx_KK_MitgliedNr,
          :doctor_id => a.ZuwArzt_ID,
          :birth_date => a.tx_Geburtsdatum,
          :created_at => a.tx_Aufnahmedatum,
          :remarks => a.mo_Bemerkung,
          :sex => a.Geschlecht_ID,
          :dunning_stop => a.tf_Mahnen,
          :use_billing_address => a.tf_fakt_Aktiv,
          :deceased => a.tf_Exitus
        )
        p.id = a.ID_Patient
        p.save
      rescue Exception => ex
        print "ID: #{a.ID_Patient} => #{ex.message}\n\n"
        print ex.backtrace.join("\n\t")
        print "\n\n"
      end
    end
  end
  
  def self.export_attributes(hozr_record)
    {
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
        :tx_fakt_Strasse => hozr_record.billing_vcard.street_address,
        :tx_fakt_Name => hozr_record.billing_vcard.family_name,
        :tx_fakt_Vorname => hozr_record.billing_vcard.given_name,
        :tx_fakt_Anrede => hozr_record.billing_vcard.honorific_prefix,
        :KK_Garant_ID => hozr_record.insurance_id,
        :tx_KK_MitgliedNr => hozr_record.insurance_nr,
        :ZuwArzt_ID => hozr_record.doctor_id,
        :tx_Geburtsdatum => hozr_record.birth_date,
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
  end
  def export_attributes
    
  end
end
