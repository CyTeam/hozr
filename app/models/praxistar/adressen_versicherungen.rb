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
end
