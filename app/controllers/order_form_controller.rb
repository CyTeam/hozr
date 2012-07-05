# encoding: utf-8'
require 'cups/print_job/transient'

class OrderFormController < ApplicationController
  helper :doctors
  
  def print
    authorize! :print, :order_form

    @doctor = Doctor.find(params[:order_form][:doctor_id])
    @count = params[:order_form][:count].to_i
    
    # Use A5
    prawnto :prawn => { :page_size => 'A5', :top_margin => 35, :left_margin => 12, :right_margin => 12, :bottom_margin => 23 }
    page = render_to_string(:template => 'order_form/print', :formats => [:pdf])
    paper_copy = Cups::PrintJob::Transient.new(page, 'hp')
    for i in 1..@count
      paper_copy.print
    end

    redirect_to order_form_path
  end
end
