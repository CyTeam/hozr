class Praxistar::AdressenAerzte < Praxistar::Base
  set_table_name "Adressen_Ärzte"
  set_primary_key "ID_Arztadresse"

  def self.import
    Doctor.delete_all

    for a in find_all
      d = Doctor.new(
        :praxis => Vcard.new(
          :locality => a.tx_Prax_Ort,
          :fax_number => a.tx_Prax_Fax,
          :phone_number => a.tx_Prax_Telefon1,
          :postal_code => a.tx_Prax_PLZ,
          :street_address => a.tx_Prax_Strasse,
          :family_name => a.tx_Name,
          :given_name => a.tx_Vorname
        ),
        :private => Vcard.new(
          :locality => a.tx_Priv_Ort,
          :fax_number => a.tx_Priv_Fax,
          :phone_number => a.tx_Priv_Telefon1,
          :postal_code => a.tx_Priv_PLZ,
          :street_address => a.tx_Priv_Strasse,
          :family_name => a.tx_Name,
          :given_name => a.tx_Vorname
        ),
        :code => a.tx_ErfassungsNr,
        :speciality => a.tx_Fachgebiet
      )
      d.id = a.ID_Arztadresse
      d.save
    end
  end
end
