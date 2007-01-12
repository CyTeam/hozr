class Praxistar::Base < ActiveRecord::Base
  require 'yaml'
  
  praxistar_connection = YAML.load(File.open(File.join(RAILS_ROOT,"config/database.yml"),"r"))["praxistar_"+ ENV['RAILS_ENV']]
  
  establish_connection(praxistar_connection)

  def self.export
    last_export = Exports.find(:first, :conditions => "model = '#{self.name}'", :order => "finished_at DESC")
    
    find_params = {
      :conditions => [ "updated_at >= ?", last_export.started_at ]
    } unless last_export.nil?
    
    export = Exports.new(:started_at => Time.now, :find_params => find_params, :model => self.name)

    for h in hozr_model.find(:all, find_params)
      attributes = export_attributes(h)
      if exists?(h.id)
        update(h.id, attributes)
        export.update_count += 1
      else
        p = new(attributes)
        p.id = h.id
        p.save
        export.create_count += 1
      end
    end
  
    export.finished_at = Time.now
    export.save
  
    print export.attributes.to_yaml
    return export
  end
end
