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
          :classification_id => a.PAP_ID,
          :praxistar_eingangsnr => sprintf("%02d", a.in_EingangJahr.to_i) + "/" + sprintf("%05d", a.in_EingangsNr.to_i),
          :entry_date => a.dt_Eingang,
          :praxistar_leistungsblatt_id => a.Leistungsblatt_ID
        )
        
        begin
            d.screener = Employee.find_by_code(a.tx_Zytologe)
        rescue ActiveRecord::RecordNotFound
        end
        
        d.id = a.ID_Praxilab
        d.save
      rescue ActiveRecord::StatementInvalid
        d.logger.info("ID: #{a.ID_Praxilab} => non unique eingangsnr\n\n")
        print "ID: #{a.ID_Praxilab} => non unique eingangsnr\n\n"
      rescue Exception => ex
        print "ID: #{a.ID_Praxilab} => #{ex.message}\n\n"
        print ex.backtrace.join("\n\t")
        print "\n\n"
      end
    end
  end
end
