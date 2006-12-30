include Cyto

class Praxistar::PraxilabDaten < Praxistar::Base
  set_table_name "Praxilab_Daten"
  set_primary_key "ID_Praxilab"

  def self.import
    Case.delete_all

    for a in find(:all, :limit => 50000)
      print "#{a.ID_Praxilab}\n"
      
      d = Case.new(
        :patient_id => a.Patient_ID,
        :doctor_id => a.Arzt_ID,
        :examination_date => a.dt_Beurteilung,
        :classification_id => a.PAP_ID
      )
      d.id = a.ID_Praxilab
      d.save
    end
  end
end
