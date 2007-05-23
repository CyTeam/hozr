class DoctorsController < ApplicationController
  in_place_edit_for :vcard, :family_name
  in_place_edit_for :vcard, :given_name
  in_place_edit_for :vcard, :street_address
  in_place_edit_for :vcard, :postal_code
  in_place_edit_for :vcard, :locality
  
  in_place_edit_for :phone_number, :number

  def index
    list
    render :action => 'list'
  end

  def list
    params[:order] ||= 'family_name, given_name'
    
    @doctors = Doctor.find :all,  :include => :praxis, :order => params[:order]
  end

  def show
    @doctor = Doctor.find(params[:id])
  end

  def new
    @doctor = Doctor.new
  end

  def create
    @doctor = Doctor.new(params[:doctor])
    @doctor.praxis = Vcard.new(params[:praxis_vcard])
    @doctor.private = Vcard.new(params[:private_vcard])
    
    if @doctor.save
      flash[:notice] = 'Doctor was successfully created.'
      redirect_to :action => 'list'
    else
      render :action => 'new'
    end
  end

  def edit
    @doctor = Doctor.find(params[:id])
  end

  def update
    @doctor = Doctor.find(params[:id])
    if @doctor.praxis.update_attributes(params[:praxis_vcard]) and @doctor.private.update_attributes(params[:private_vcard]) and @doctor.update_attributes(params[:doctor])
      flash[:notice] = 'Doctor was successfully updated.'
      redirect_to :action => 'show', :id => @doctor
    else
      render :action => 'edit'
    end
  end

  def destroy
    Doctor.find(params[:id]).destroy
    redirect_to :action => 'list'
  end


  def print_letter
    system("/usr/local/bin/hozr_print_doctor_letter.sh", params[:id])
    render :text => 'Gedruckt'
  end
end
