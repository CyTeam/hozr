class DoctorsController < ApplicationController
  def index
    list
    render :action => 'list'
  end

  def list
    @doctor_pages, @doctors = paginate :doctors, :per_page => 10
  end

  def show
    @doctor = Doctor.find(params[:id])
    @vcard = @doctor.vcard
  end

  def new
    @doctor = Doctor.new
  end

  def create
    @doctor = Doctor.new(params[:doctor])
    @doctor.vcard = Vcard.new(params[:vcard])
    
    if @doctor.save
      flash[:notice] = 'Doctor was successfully created.'
      redirect_to :action => 'list'
    else
      render :action => 'new'
    end
  end

  def edit
    @doctor = Doctor.find(params[:id])
    @vcard = @doctor.vcard
  end

  def update
    @doctor = Doctor.find(params[:id])
    @vcard = @doctor.vcard
    if @vcard.update_attributes(params[:vcard]) and @doctor.update_attributes(params[:doctor])
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
