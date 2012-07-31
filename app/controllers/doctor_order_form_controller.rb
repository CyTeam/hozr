# encoding: utf-8'
require 'cups/print_job/transient'

class DoctorOrderFormController < ApplicationController
  helper :doctors
  
  def print
    authorize! :print, :doctor_order_form

    @doctor = Doctor.find(params[:doctor_order_form][:doctor_id])
    @count = params[:doctor_order_form][:count].to_i
    
    # Use A5
    prawnto :prawn => { :page_size => 'A5', :top_margin => 35, :left_margin => 12, :right_margin => 12, :bottom_margin => 23 }
    page = render_to_string(:template => 'doctor_order_form/print', :formats => [:pdf])

    # Workaround TransientJob not yet accepting options
    file = Tempfile.new('')
    file.binmode
    file.puts(page)
    file.close

    printer = 'hp'
    for i in 1..@count
      begin
        paper_copy = Cups::PrintJob.new(file.path, printer)
      rescue
        paper_copy = Cups::PrintJob.new(file.path, printer)
      end
      paper_copy.print
    end

    redirect_to doctor_order_form_path
  end
end
