require 'cups/print_job/transient'

class OrderFormController < ApplicationController
  authorize_resource :class => false

  helper :doctors
  
  
  def print
    @doctor = Doctor.find(params[:order_form][:doctor_id])
    @count = params[:order_form][:count].to_i
    
    respond_to do |format|
      format.html {}
      format.pdf {
        # Use A5
        prawnto :prawn => { :page_size => 'A5', :top_margin => 35, :left_margin => 12, :right_margin => 12, :bottom_margin => 23 }
        page = render_to_string(:layout => false)
        paper_copy = Cups::PrintJob::Transient.new(page, 'hp')
        for i in 1..@count
          paper_copy.print
        end
        render :update do |page|
          page.replace_html 'print_flash', "#{@count} Formulare für #{@doctor.name} gedruckt."
          page.show 'print_flash'
        end
      }
    end
  end

end
