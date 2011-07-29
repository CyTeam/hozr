class Praxistar::AdressenVersicherungen < Praxistar::Base
  set_table_name "Adressen_Versicherungen"
  set_primary_key "ID_Versicherung"

  def self.hozr_model
    Insurance
  end

  def self.export_attributes(hozr_record, new_record)
    {
      :tx_Telefon => hozr_record.phone_number,
      :tx_Ort => hozr_record.locality,
      :tx_FAX => hozr_record.fax_number,
      :tx_ZuHanden => hozr_record.extended_address,
      :tx_PLZ => hozr_record.postal_code,
      :tx_Strasse => hozr_record.street_address,
      :tx_Name => hozr_record.name
    }
  end
end
