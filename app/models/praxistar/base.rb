class Praxistar::Base < ActiveRecord::Base
  establish_connection(
    :adapter => 'sqlserver',
    :mode => 'odbc',
    :dsn => 'praxistar',
    :username => 'sa',
    :password => 'pioneer'
  )
end
