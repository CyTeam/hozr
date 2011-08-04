module LabelPrintHelper
  def label_select
    Case.for_second_entry.collect { |m| [ m.praxistar_eingangsnr ] }
  end

  def label
    Vcard.find(Doctor.find(params[:order_form][:doctor_id]).praxis_vcard)
  end
end
