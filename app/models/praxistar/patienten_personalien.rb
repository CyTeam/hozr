class Praxistar::PatientenPersonalien < Praxistar::Base
  set_table_name "Patienten_Personalien"
  set_primary_key "ID_Patient"
  
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
            :given_name => a.tx_Vorname
          ),
          :billing_vcard => Vcard.new(
            :locality => a.tx_fakt_Ort,
            :postal_code => a.tx_fakt_PLZ,
            :street_address => a.tx_fakt_Strasse,
            :family_name => a.tx_fakt_Name,
            :given_name => a.tx_fakt_Vorname,
            :extended_address => a.tx_fakt_ZuHanden
          ),
          :insurance_id => a.KK_Garant_ID,
          :insurance_nr => a.tx_KK_MitgliedNr,
          :doctor_id => a.ZuwArzt_ID,
          :birth_date => a.tx_Geburtsdatum,
          :created_at => a.tx_Aufnahmedatum,
          :updated_at => a.dt_Mutationsdatum,
          :remarks => a.mo_Bemerkung,
          :sex => a.Geschlecht_ID,
          :dunning_stop => a.tf_Mahnen,
          :use_billing_address => a.tf_fakt_Aktiv
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
end
