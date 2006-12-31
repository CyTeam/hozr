include Cyto

class Praxistar::PraxilabZuordnung < Praxistar::Base
  set_table_name "Praxilab_Zuordnung"

  def self.import
    #Classification.delete_all

    for a in find(:all, :limit => 100)
      print "#{a.Praxilab_ID}\n"
      
      begin
        c = Cyto::Case.find(a.Praxilab_ID)
        c.finding_classes<< FindingClass.find(a.Diagnosenliste_ID)
      rescue ActiveRecord::RecordNotFound
        print " not yet imported\n"
      end
    end
  end
end
