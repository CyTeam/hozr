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
end
