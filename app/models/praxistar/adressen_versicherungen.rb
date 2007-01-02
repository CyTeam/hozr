class Praxistar::AdressenVersicherungen < Praxistar::Base
  set_table_name "Adressen_Versicherungen"
  set_primary_key "ID_Versicherung"

  def self.import
    Insurance.delete_all

    for a in find_all
      i = Insurance.new(
        :phone_number => a.tx_Telefon,
        :locality => a.tx_Ort,
        :fax_number => a.tx_FAX,
        :extended_address => a.tx_ZuHanden,
        :postal_code => a.tx_PLZ,
        :street_address => a.tx_Strasse,
        :name => a.tx_Name
      )
      i.id = a.ID_Versicherung
      i.save
    end
  end

  def self.export
    last_export = Exports.find(:first, :conditions => "model = '#{self.name}'", :order => "finished_at DESC")
    
    find_params = {
      :conditions => [ "updated_at >= ?", last_export.started_at ]
    }
    export = Exports.new(:started_at => Time.now, :find_params => find_params, :model => self.name)

    for h in Insurance.find(:all, find_params)
      attributes = {
        :tx_Telefon => h.phone_number,
        :tx_Ort => h.locality,
        :tx_FAX => h.fax_number,
        :tx_ZuHanden => h.extended_address,
        :tx_PLZ => h.postal_code,
        :tx_Strasse => h.street_address,
        :tx_Name => h.name
      }
      if exists?(h.id)
        update(h.id, attributes)
        export.update_count += 1
      else
        p = new(attributes)
        p.id = h.id
        p.save
        export.create_count += 1
      end
    end
  
    export.finished_at = Time.now
    export.save
  end
end
