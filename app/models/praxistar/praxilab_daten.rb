include Cyto

class Praxistar::PraxilabDaten < Praxistar::Base
  set_table_name "Praxilab_Daten"
  set_primary_key "ID_Praxilab"

  def self.import
    for a in find(:all, :conditions => "dt_eingang > '2007' AND in_EingangJahr = '06'")
      begin
	print "Nr: #{a.in_EingangsNr}\n"
        d = Case.new(
          :patient_id => a.Patient_ID,
          :doctor_id => a.Arzt_ID,
          :examination_date => a.dt_Beurteilung,
          :classification_id => a.PAP_ID,
          :praxistar_eingangsnr => sprintf("%02d", a.in_EingangJahr.to_i) + "/" + sprintf("%05d", a.in_EingangsNr.to_i),
          :entry_date => a.dt_Eingang,
          :praxistar_leistungsblatt_id => a.Leistungsblatt_ID
        )
        
	print "Nr: #{a.in_EingangsNr} created \n"
        begin
          d.screener = Employee.find_by_code(a.tx_Zytologe)
        rescue ActiveRecord::RecordNotFound
          #d.logger.info "ID: #{a.ID_Praxilab} => screener '#{d.screener}' not found"
        end
        
        d.save!
	print "Nr: #{a.in_EingangsNr} saved: #{d.id} \n"

      rescue ActiveRecord::StatementInvalid
        d.logger.info("ID: #{a.ID_Praxilab} => non unique eingangsnr '#{d.praxistar_eingangsnr}''\n\n")
        print "ID: #{a.ID_Praxilab} => non unique eingangsnr '#{d.praxistar_eingangsnr}'\n\n"
      rescue Exception => ex
        print "ID: #{a.ID_Praxilab} => #{ex.message}\n\n"
        print ex.backtrace.join("\n\t")
        print "\n\n"
      end
    end
  end
end
