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
            :postal_code => a.tx_PLZ,
            :street_address => a.tx_Strasse,
            :family_name => a.tx_Name,
            :given_name => a.tx_Vorname
          ),
          :insurance_id => a.KK_Garant_ID,
          :insurance_nr => a.tx_KK_MitgliedNr,
          :doctor_id => a.ZuwArzt_ID,
          :birth_date => a.tx_Geburtsdatum
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
