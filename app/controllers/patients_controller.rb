class PatientsController < ApplicationController
  helper :doctors
  
  auto_complete_for_vcard :vcard
  auto_complete_for_vcard :billing_vcard
  
  # Lists
  def index
    list
    render :action => 'list'
  end

  def dunning_stopped
    @patients = Patient.dunning_stopped.all
  end
  
  # Search helpers
  include Controller::Search
  
  def search
    @case = Case.find(params[:case_id]) unless params[:case_id].nil?

    # If entry_nr is given, take it as the only condition
    eingangsnr = params[:search][:praxistar_eingangsnr]
    if !eingangsnr.empty?
      search_by_eingangsnr
      return
    end

    keys = []
    values = []

    default_vcard_keys, *default_vcard_values = vcard_conditions
    
    unless default_vcard_keys.nil?
      keys.push "( #{default_vcard_keys} )"
      values.push *default_vcard_values
    end

    patient_keys, *patient_values = patient_conditions
    keys.push patient_keys
    values.push *patient_values
    
    # Build conditions array
    if keys.compact.empty?
      @patients = []
    else
      conditions = !keys.compact.empty? ? [  keys.compact.join(" AND "), *values ] : nil
      @patients = Patient.find :all, :conditions => conditions, :include => {:vcard => :address}, :order => 'vcards.family_name'
    end
    
    render :partial => 'list'
  end
  
  def search_by_eingangsnr
    @patients = [ Patient.find(Case.find_by_praxistar_eingangsnr(CaseNr.new(params[:search][:praxistar_eingangsnr]).to_s).patient_id) ]
  
    render :partial => 'list'
  end
  
  def list
     @patients = []
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
    @vcard.honorific_prefix = 'Frau'

    if params[:case_id]
      @case = Case.find(params[:case_id])
      @patient.doctor = @case.doctor
    end

    render :partial => 'new'
  end

  def create
    @patient = Patient.new(params[:patient])
    @patient.vcard = Vcard.new(params[:vcard])
    @patient.billing_vcard = Vcard.new(params[:billing_vcard])
    
    @patient.sex = HonorificPrefix.find_by_name(@patient.vcard.honorific_prefix).sex

    if @patient.save
      flash[:notice] = 'Patient was successfully created.'
      redirect_to :action => 'list'
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
      @patient.delete_leistungsblaetter
      @patient.reactivate_open_invoices

      flash[:notice] = 'Patientendaten mutiert'
      redirect_to :action => 'list'
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
    render :partial => 'edit'
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
      @patient.delete_leistungsblaetter
      @patient.reactivate_open_invoices

      flash[:notice] = 'Patientendaten mutiert'
      redirect_to :action => 'list'
    else
      render :action => 'edit'
    end
  end

  def delete_leistungsblaetter
    @patient = Patient.find(params[:id])
    
    @patient.delete_leistungsblaetter
    render :text => 'Leistungeblaetter gelöscht.'
  end
  
  def destroy
    Patient.find(params[:id]).destroy
    redirect_to :action => 'list'
  end
end
