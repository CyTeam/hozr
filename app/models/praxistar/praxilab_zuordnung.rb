include Cyto

class Praxistar::PraxilabZuordnung < Praxistar::Base
  set_table_name "Praxilab_Zuordnung"

  def self.import
    Classification.connection.delete('DELETE FROM cases_finding_classes')

    for a in find(:all)
      begin
        c = Cyto::Case.find(a.Praxilab_ID)
        c.finding_classes<< FindingClass.find(a.Diagnosenliste_ID)
      rescue ActiveRecord::RecordNotFound
        print "ID: #{a.Praxilab_ID} => not yet imported\n"
      rescue Exception => ex
        print "ID: #{a.Praxilab_ID}, Diagnose: #{a.Diagnosenliste_ID} => #{ex.message}\n\n"
        print ex.backtrace.join("\n\t")
        print "\n\n"
      end
    end
  end
end
