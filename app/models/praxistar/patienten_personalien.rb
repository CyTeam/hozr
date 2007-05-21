class Praxistar::PatientenPersonalien < Praxistar::Base
  set_table_name "Patienten_Personalien"
  set_primary_key "ID_Patient"
  
  def self.hozr_model
    Patient
  end
  
  def self.import_attributes(a)
    {
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
      :deceased => a.tf_Exitus,
    }
  end
  
  def self.import
    last_import = Imports.find(:first, :conditions => "model = '#{self.name}'", :order => "finished_at DESC")
    
    find_params = {
      :conditions => [ "dt_mutationsdatum > ? OR tx_aufnahmedatum >= ? ", last_import.started_at, last_import.started_at ]
    } unless last_import.nil?
    
    import = Imports.new(:started_at => Time.now, :find_params => find_params, :model => self.name)
    
#    hozr_model.Patient.delete_all
    
    records = find(:all, find_params)
    
    import.record_count = records.size
    import.save
    
    for praxistar_record in records
      begin
        attributes = import_attributes(praxistar_record)

        if hozr_model.exists?(praxistar_record.id)
          hozr_model.update(praxistar_record.id, attributes)
          
          import.update_count += 1
        else
          hozr_record = hozr_model.new(attributes)
          hozr_record.id = praxistar_record.id
          hozr_record.save
        
          import.create_count += 1
        end
        
        import.save
      
      rescue Exception => ex
        import.error_ids += h.id
        import.error_count += 1
        import.save
        
        print "ID: #{praxistar_record.id} => #{ex.message}\n\n"
        logger.info "ID: #{praxistar_record.id} => #{ex.message}\n\n"
        logger.info ex.backtrace.join("\n\t")
        logger.info "\n"
      end
    end
  
    import.finished_at = Time.now
    import.save
    
    print import.attributes.to_yaml
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
        
        :ln_Patienten_Nr => hozr_record.id + 200000,
        
        # const attributes
        :Mandant_ID => 1
      }
  end
end
