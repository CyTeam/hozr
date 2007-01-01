include Cyto

class Praxistar::PraxilabDaten < Praxistar::Base
  set_table_name "Praxilab_Daten"
  set_primary_key "ID_Praxilab"

  def self.import
    Case.delete_all

    for a in find(:all)
      begin
        d = Cyto::Case.new(
          :patient_id => a.Patient_ID,
          :doctor_id => a.Arzt_ID,
          :examination_date => a.dt_Beurteilung,
          :classification_id => a.PAP_ID
        )
        
        begin
            d.screener = Employee.find_by_code(a.tx_Zytologe)
        rescue ActiveRecord::RecordNotFound
        end
        
        d.id = a.ID_Praxilab
        d.save
      rescue Exception => ex
        print "ID: #{a.ID_Patient} => #{ex.message}\n\n"
        print ex.backtrace.join("\n\t")
        print "\n\n"
      end
    end
  end
end
