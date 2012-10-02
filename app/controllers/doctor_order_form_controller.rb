# encoding: utf-8'
require 'cups/print_job/transient'

class DoctorOrderFormController < ApplicationController
  helper :doctors
  
  def print
    authorize! :print, :doctor_order_form

    @doctor = Doctor.find(params[:doctor_order_form][:doctor_id])
    @count = params[:doctor_order_form][:count].to_i
    
    pdf = DoctorOrderForm.new(@doctor)

    for i in 1..@count
      pdf.print('hp')
    end
  end
end
