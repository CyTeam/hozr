class PatientsController < ApplicationController
  helper :doctors
  
  auto_complete_for_vcard :vcard
  auto_complete_for_vcard :billing_vcard
  
  def auto_complete_for_patient_full_name
    @patients = Patient.find(:all, 
      :conditions => [ Patient.connection.concat(:family_name, ' ', :given_name) + " LIKE ?",
      '%' + params[:patient][:full_name].downcase.gsub(' ', '%') + '%' ], 
      :joins => "JOIN vcards ON patients.vcard_id = vcards.id",
      :select => "patients.*",
      :order => 'family_name ASC',
      :limit => 30)
    render :partial => 'full_names'
  end
    
  def index
    list
    render :action => 'list'
  end

  def search
    conditions = {:sql => [], :params => []}
    if params[:patient][:full_name] > ""
      conditions[:sql]<< "id = ?"
      conditions[:params]<< Patient.find(params[:patient][:full_name].split(' ')[0].to_i).id
    end
    if params[:patient][:praxistar_eingangsnr] > ""
      conditions[:sql]<< "id = ?"
      conditions[:params]<< Case.find_by_praxistar_eingangsnr(Cyto::CaseNr.new(params[:patient][:praxistar_eingangsnr]).to_s).patient_id
    end
    
    @patient_pages, @patients = paginate :patients, :per_page => 144, :conditions => [ conditions[:sql].join(" AND "), conditions[:params] ]
  
    render :action => :list
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
