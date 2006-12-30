include Cyto

class Praxistar::PraxilabPap < Praxistar::Base
  set_table_name "Praxilab_PAP"
  set_primary_key "ID_PAP"
  
  def self.import
    Classification.delete_all
    
    for a in find(:all)
      print "#{a.ID_PAP}\n"
      p = Classification.new(
        :method_id => a.tf_Neu,
        :code => a.tx_PAP
      )
      p.id = a.ID_PAP
      p.save
    end
  end
end
