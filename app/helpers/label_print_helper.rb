module LabelPrintHelper
  def label_select
    Case.for_second_entry.collect { |m| [ m.praxistar_eingangsnr ] }
  end

  def doctors_collection
    Doctor.find(:all, :include => {:praxis => :address}, :order => 'vcards.family_name, vcards.given_name', :conditions => {:active => true}).collect { |m| [ [ m.family_name, m.given_name ].join(", ") + " (#{m.praxis.locality})", m.id ] }
  end

  def label
   Vcard.find(Doctor.find(params[:order_form][:doctor_id]).praxis_vcard)
  end
end
