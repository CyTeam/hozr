class DoctorsController < ApplicationController
  def index
    list
    render :action => 'list'
  end

  def list
    params[:order] ||= 'family_name, given_name'
    
    @doctor_pages, @doctors = paginate :doctors, :per_page => 100, :include => :praxis, :order => params[:order]
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
end
