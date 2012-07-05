# encoding: utf-8'
class PatientsController < AuthorizedController
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
    @insurance = @patient.insurance
    @doctor = @patient.doctor
  end

  def new
    @patient = Patient.new(params[:patient])
    @patient.build_vcard unless @patient.vcard
    @patient.build_billing_vcard unless @patient.billing_vcard
    
    @patient.vcard.honorific_prefix = 'Frau'
  end

  def create
    @patient = Patient.new(params[:patient])
    
    # Deduce sex from honorific_prefix
    @patient.sex = HonorificPrefix.find_by_name(@patient.vcard.honorific_prefix).sex

    if @patient.save
      flash[:notice] = 'Patient was successfully created.'
      redirect_to @patient
    else
      render :action => :new
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

    if params[:case_id]
      @case = Case.find(params[:case_id])
      @patient.doctor = @case.doctor
    end

    @vcard.honorific_prefix ||= HonorificPrefix.find_by_name('Frau')
  end

  def update
    @patient = Patient.find(params[:id])
    
    if @patient.update_attributes(params[:patient])

      flash[:notice] = 'Patientendaten mutiert'
      redirect_to @patient
    else
      render :show
    end
  end

  def destroy
    Patient.find(params[:id]).destroy
    redirect_to patients_path
  end
end
