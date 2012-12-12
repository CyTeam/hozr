# encoding: utf-8'
class DoctorOrderFormController < LabelPrintController
  def print
    authorize! :print, :doctor_order_form

    @doctor = Doctor.find(params[:doctor_order_form][:doctor_id])
    @count = params[:doctor_order_form][:count].to_i

    pdf = DoctorOrderForm.new(@doctor)

    pdf.print(current_tenant.printer_for(:order_form), @count)
  end
end
