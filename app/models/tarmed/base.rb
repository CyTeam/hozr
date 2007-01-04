class Tarmed::Base < ActiveRecord::Base
  require 'yaml'
  
  tarmed_connection = YAML.load(File.open(File.join(RAILS_ROOT,"config/database.yml"),"r"))["tarmed"]
  
  establish_connection(tarmed_connection)

  def lang
    'D'
  end
end
