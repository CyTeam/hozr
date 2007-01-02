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
    for h in Insurance.find(:all)
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
      else
        p = new(attributes)
        p.id = h.id
        p.save
      end
    end
  end
end
