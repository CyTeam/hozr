class PatientsController < ApplicationController
  def index
    list
    render :action => 'search'
  end

  def list
    @patient_pages, @patients = paginate :patients, :per_page => 10
  end

  def show
    @patient = Patient.find(params[:id])
    @vcard = @patient.vcard
    @insurance = @patient.insurance
    @doctor = @patient.doctor
  end

  def new
    @patient = Patient.new
    @insurances = Insurance.find_all
    @doctors = Doctor.find_all
  end

  def create
    @patient = Patient.new(params[:patient])
    @patient.vcard = Vcard.new(params[:vcard])
    @patient.billing_vcard = Vcard.new(params[:billing_vcard])
    if @patient.save
      flash[:notice] = 'Patient was successfully created.'
      redirect_to :action => 'search'
    else
      render :action => 'new'
    end
  end

  def form
    @patient = Patient.find(params[:id])
  end

  def update_form
    @patient = Patient.find(params[:id])
    if @patient.update_attributes(params[:patient])
      flash[:notice] = 'Patientendaten mutiert'
      redirect_to :action => 'search'
    else
      render :action => 'form'
    end
  end

  def edit
    @patient = Patient.find(params[:id])
    @vcard = @patient.vcard
    @billing_vcard = @patient.billing_vcard
    @insurances = Insurance.find_all
    @doctors = Doctor.find_all
  end

  def update
    @patient = Patient.find(params[:id])
    @vcard = @patient.vcard
    if @patient.billing_vcard.nil?
      @patient.create_billing_vcard
    end
    @billing_vcard = @patient.billing_vcard
    if @vcard.update_attributes(params[:vcard]) and @billing_vcard.update_attributes(params[:billing_vcard]) and @patient.update_attributes(params[:patient])
      flash[:notice] = 'Patient was successfully updated.'
      redirect_to :action => 'list'
    else
      render :action => 'edit'
    end
  end

  def destroy
    Patient.find(params[:id]).destroy
    redirect_to :action => 'list'
  end
end
