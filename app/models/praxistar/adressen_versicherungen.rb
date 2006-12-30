class Praxistar::AdressenVersicherungen < ActiveRecord::Base
  set_table_name "Adressen_Versicherungen"
  set_primary_key "ID_Versicherung"

  establish_connection(
    :adapter => 'sqlserver',
    :mode => 'odbc',
    :dsn => 'praxistar',
    :username => 'sa',
    :password => 'pioneer'
  )

  def self.import
    for a in find_all
      Insurance.new(
        :id => a.ID_Versicherung,
        :phone_number => a.tx_Telefon,
        :locality => a.tx_Ort,
        :fax_number => a.tx_FAX,
        :extended_address => a.tx_ZuHanden,
        :postal_code => a.tx_PLZ,
        :street_address => a.tx_Strasse,
        :name => a.tx_Name
      ).save
    end
  end
end
