module LabelPrintHelper
 def label_select
	Case.find(:all, :conditions => "entry_date IS NOT NULL AND screened_at IS NULL AND (needs_p16 = '#{Case.connection.false}' AND needs_hpv = '#{Case.connection.false}') AND praxistar_eingangsnr AND praxistar_eingangsnr > '07' AND praxistar_eingangsnr < '90' AND NOT praxistar_eingangsnr LIKE '%-%'").collect { |m| [ m.praxistar_eingangsnr ] }
 end

 def doctors_collection
    Doctor.find(:all, :include => {:praxis => :address}, :order => 'vcards.family_name, vcards.given_name', :conditions => {:active => true}).collect { |m| [ [ m.family_name, m.given_name ].join(", ") + " (#{m.praxis.locality})", m.id ] }
 end

def label
Vcard.find(Doctor.find(params[:order_form][:doctor_id]).praxis_vcard)
end

end
