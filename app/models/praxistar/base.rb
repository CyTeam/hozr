class Praxistar::Base < ActiveRecord::Base
  require 'yaml'
  
  praxistar_connection = YAML.load(File.open(File.join(RAILS_ROOT,"config/database.yml"),"r"))["praxistar_"+ ENV['RAILS_ENV']]
  
  establish_connection(praxistar_connection)
end
