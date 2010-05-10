class OrderFormController < ApplicationController
  helper :doctors
  
  def print
    @doctor = Doctor.find(params[:order_form][:doctor_id])
    @count = params[:order_form][:count]
    
    respond_to do |format|
      format.html {}
      format.pdf {
        # Use A5
        prawnto :prawn => { :page_size => 'A5', :top_margin => 60, :left_margin => 35, :right_margin => 35, :bottom_margin => 23 }
        render :layout => false
      }
    end
  end

end
