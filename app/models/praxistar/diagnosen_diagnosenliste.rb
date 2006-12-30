include Cyto

class Praxistar::DiagnosenDiagnosenliste < Praxistar::Base
  set_table_name "Diagnosen_Diagnosenliste"
  set_primary_key "ID_Diagnosenliste"

  def self.import
    FindingClass.delete_all

    for a in find(:all)
      print "#{a.ID_Diagnosenliste}\n"
      p = FindingClass.new(
        :name => a.tx_Diagnosentext,
        :code =>a.tx_Erfassungscode
      )
      p.id = a.ID_Diagnosenliste
      p.save
    end
  end
end
