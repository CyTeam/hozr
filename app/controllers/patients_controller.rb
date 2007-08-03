include Cyto

class PatientsController < ApplicationController
  helper :doctors
  
  auto_complete_for_vcard :vcard
  auto_complete_for_vcard :billing_vcard
  
  in_place_edit_for :vcard, :family_name
  in_place_edit_for :vcard, :given_name
  in_place_edit_for :vcard, :street_address
  in_place_edit_for :vcard, :postal_code
  in_place_edit_for :vcard, :locality
  in_place_edit_for :patient, :birth_date
  in_place_edit_for :patient, :in_place_doctor_patient_nr
  in_place_edit_for :patient, :in_place_insurance_nr
  
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

  def parse_date(value)
    if value.is_a?(String)
      if value.match /.*-.*-.*/
        return value
      end
      day, month, year = value.split('.').map {|s| s.to_i}
      month ||= Date.today.month
      year ||= Date.today.year
      year = expand_year(year, 1900)
      
      return sprintf("%4d-%02d-%02d", year, month, day)
    else
      return value
    end
  end
  
  def date_only_year?(value)
    value.is_a?(String) and value.strip.match /^\d{2,4}$/
  end
  
  def expand_year(value, base = 1900)
    year = value.to_i
    return year < 100 ? year + base : year
  end
  
  def vcard_conditions
    vcard_params = params[:vcard] || {}
    keys = []
    values = []
    
    fields = vcard_params.reject { |key, value| value.nil? or value.empty? }
    fields.each { |key, value|
      keys.push "#{key} LIKE ?"
      values.push '%' + value.downcase.gsub(' ', '%') + '%'
    }
    
    return !keys.empty? ? [ keys.join(" AND "), *values ] : nil
  end
  
  def patient_conditions
    parameters = params[:patient]
    keys = []
    values = []
    
    unless parameters[:full_name].nil? or patient_parameters[:full_name].empty?
      keys.push "patient_id = ?"
      values.push patient_parameters[:full_name].split(' ')[0].strip
    end
    
    unless parameters[:birth_date].nil? or parameters[:birth_date].empty?
      if parameters[:birth_date].match /bis/
        lower_bound, higher_bound = parameters[:birth_date].split('bis')
        if date_only_year?(lower_bound)
            keys.push "YEAR(birth_date) BETWEEN ? AND ?"
            values.push expand_year(lower_bound.strip)
            values.push expand_year(higher_bound.strip)
        else
            keys.push "birth_date BETWEEN ? AND ?"
            values.push parse_date(lower_bound.strip).strip
            values.push parse_date(higher_bound.strip).strip
        end
      else
        if date_only_year?(parameters[:birth_date])
            keys.push "YEAR(birth_date) = ?"
            values.push expand_year(parameters[:birth_date].strip)
        else
            keys.push "birth_date = ? "
            values.push parse_date(parameters[:birth_date]).strip
        end
      end
    end
  
    return !keys.empty? ? [ keys.join(" AND "), *values ] : nil
  end
  
  def search
    # If entry_nr is given, take it as the only condition
    eingangsnr = params[:patient][:praxistar_eingangsnr]
    if !eingangsnr.empty?
      search_by_eingangsnr
      return
    end

    if vcard_conditions
        vcard_ids = Vcard.find :all, :include => :address, :limit => 1000, :conditions => vcard_conditions, :select => 'id'
    
        vcard_keys = "(vcard_id IN (#{vcard_ids.map {|vcard| vcard.id}.join ', '}) OR billing_vcard_id IN (#{vcard_ids.map {|vcard| vcard.id}.join ', '}))"
    else
        vcard_keys = nil
    end
    
    keys = [vcard_keys]
    values = []
    
    patient_keys, *patient_values = patient_conditions
    keys.push patient_keys
    values.push *patient_values
    
    # Build conditions array
    if keys.compact.empty?
      @patients = []
    else
      conditions = !keys.compact.empty? ? [  keys.compact.join(" AND "), *values ] : nil
      @patients = Patient.find :all, :conditions => conditions
    end
    
    render :partial => 'list'
  end
  
  def search_by_eingangsnr
    @patients = [ Patient.find(Cyto::Case.find_by_praxistar_eingangsnr(Cyto::CaseNr.new(params[:patient][:praxistar_eingangsnr]).to_s).patient_id) ]
  
    render :partial => 'list'
  end
  
  def list
     @patients = []
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
      @patient.save
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
