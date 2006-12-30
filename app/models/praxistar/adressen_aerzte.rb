class Praxistar::AdressenAerzte < Praxistar::Base
  set_table_name "Adressen_Ärzte"
  set_primary_key "ID_Arztadresse"

  establish_connection(
    :adapter => 'sqlserver',
    :mode => 'odbc',
    :dsn => 'praxistar',
    :username => 'sa',
    :password => 'pioneer'
  )

  def self.import
    for a in find_all
      Doctor.new(
        :id => a.ID_Arztadresse,
        :vcard => Vcard.new(
          :locality => a.tx_Prax_Ort,
          :fax_number => a.tx_Prax_Fax,
          :phone_number => a.tx_Prax_Telefon1,
          :postal_code => a.tx_Prax_PLZ,
          :street_address => a.tx_Prax_Strasse,
          :family_name => a.tx_Name,
          :given_name => a.tx_Vorname
        ),
        :code => a.tx_ErfassungsNr,
        :speciality => a.tx_Fachgebiet
      ).save
    end
  end

end
