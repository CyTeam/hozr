module LabelPrintHelper
 def label_select
	Case.find(:all, :conditions => "entry_date IS NOT NULL AND screened_at IS NULL AND (needs_p16 = '#{Case.connection.false}' AND needs_hpv = '#{Case.connection.false}') AND praxistar_eingangsnr AND praxistar_eingangsnr > '07' AND praxistar_eingangsnr < '90' AND NOT praxistar_eingangsnr LIKE '%-%'").collect { |m| [ m.praxistar_eingangsnr ] }
 end

end
