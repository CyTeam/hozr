class PatientsController < ApplicationController
  helper :doctors
  
  auto_complete_for_vcard :vcard
  auto_complete_for_vcard :billing_vcard
  
  def index
    @patients = Patient.search :per_page => 50
  end

  def dunning_stopped
    @patients = Patient.dunning_stopped.all
  end
  
  def show
    @patient = Patient.find(params[:id])
    @vcard = @patient.vcard
    @billing_vcard = @patient.billing_vcard
    @insurance = @patient.insurance
    @doctor = @patient.doctor
  end

  def new
    patient = params[:patient]
    @patient = Patient.new(patient)
    @vcard = Vcard.new(params[:vcard])
    @patient.billing_vcard = Vcard.new(params[:billing_vcard])
    
    @vcard.honorific_prefix = 'Frau'
  end

  def create
    @patient = Patient.new(params[:patient])
    @vcard = @patient.vcard = Vcard.new(params[:vcard])
    @billing_vcard = @patient.billing_vcard = Vcard.new(params[:billing_vcard])
    
    @patient.sex = HonorificPrefix.find_by_name(@patient.vcard.honorific_prefix).sex

    if @patient.save
      flash[:notice] = 'Patient was successfully created.'
      redirect_to patients_path
    else
      render :action => 'new'
    end
  end

  def form
    @patient = Patient.find(params[:id])
  end

  def update_form
    @patient = Patient.find(params[:id])
    params[:patient][:sex] = HonorificPrefix.find_by_name(@patient.vcard.honorific_prefix).sex
    
    if @patient.update_attributes(params[:patient])
      @patient.touch

      flash[:notice] = 'Patientendaten mutiert'
      redirect_to patients_path
    else
      render :action => 'form'
    end
  end

  def edit
    @patient = Patient.find(params[:id])
    @vcard = @patient.vcard
    @billing_vcard = @patient.billing_vcard

    if params[:case_id]
      @case = Case.find(params[:case_id])
      @patient.doctor = @case.doctor
    end

    @vcard.honorific_prexif = HonorificPrefix.find_by_name('Frau') if @vcard.honorific_prefix.nil?
  end

  def edit_inline
    edit
  end

  def update
    @patient = Patient.find(params[:id])
    @vcard = @patient.vcard
    if @patient.billing_vcard.nil?
      @patient.create_billing_vcard
    end
    @billing_vcard = @patient.billing_vcard
    
    params[:patient][:sex] = HonorificPrefix.find_by_name(params[:vcard][:honorific_prefix]).sex

    if @vcard.update_attributes(params[:vcard]) and @billing_vcard.update_attributes(params[:billing_vcard]) and @patient.update_attributes(params[:patient])
      @vcard.save
      @patient.touch

      flash[:notice] = 'Patientendaten mutiert'
      redirect_to @patient
    else
      render :action => 'edit'
    end
  end

  def destroy
    Patient.find(params[:id]).destroy
    redirect_to patients_path
  end
end
