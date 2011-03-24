include Cyto

class Praxistar::PraxilabZuordnung < Praxistar::Base
  set_table_name "Praxilab_Zuordnung"

  def self.import
    Classification.connection.delete('DELETE FROM cases_finding_classes')

    for a in find(:all)
      begin
        print "#{a.Praxilab_ID}\n"
        c = Case.find(a.Praxilab_ID)
        c.finding_classes<< FindingClass.find(a.Diagnosenliste_ID)
      rescue ActiveRecord::RecordNotFound
        c.logger.info "ID: #{a.Praxilab_ID} => not yet imported\n"
        print "ID: #{a.Praxilab_ID} => not yet imported\n"
      rescue Exception => ex
        print "ID: #{a.Praxilab_ID}, Diagnose: #{a.Diagnosenliste_ID} => #{ex.message}\n\n"
        c.logger.info "ID: #{a.Praxilab_ID}, Diagnose: #{a.Diagnosenliste_ID} => #{ex.message}\n\n"
        c.logger.info ex.backtrace.join("\n\t")
        c.logger.info "\n\n"
      end
    end
  end
end
