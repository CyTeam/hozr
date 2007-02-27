include Cyto

class SearchController < ApplicationController
  helper :doctors
  
  def auto_complete_for_patient_full_name
    @patients = Patient.find(:all, 
      :conditions => [ Patient.connection.concat(:family_name, ' ', :given_name) + " LIKE ?",
      '%' + params[:patient][:full_name].downcase.gsub(' ', '%') + '%' ], 
      :joins => "JOIN vcards ON patients.vcard_id = vcards.id",
      :select => "patients.*",
      :order => 'family_name ASC',
      :limit => 30)
    render :partial => '/patients/full_names'
  end

  def index
    redirect_to :action => :search_form
  end
  
  def search_form
  end

  def parse_date(value)
    if value.is_a?(String)
      if value.match /.*-.*-.*/
        return value
      end
      day, month, year = value.split('.')
      month ||= Date.today.month
      year ||= Date.today.year
      year = 2000 + year.to_i if year.to_i < 100
      
      return sprintf("%4d-%02d-%02d", year, month, day)
    else
      return value
    end
  end
  
  def search
    # Use key and value arrays to build contitions
    case_keys = []
    case_values = []
    
    # Handle case params
    case_params = params[:case]
    
    unless case_params[:praxistar_eingangsnr].empty?
      if case_params[:praxistar_eingangsnr].match /bis/
        lower_bound, higher_bound = case_params[:praxistar_eingangsnr].split('bis')
        case_keys.push "praxistar_eingangsnr BETWEEN ? AND ?"
        case_values.push Cyto::CaseNr.new(lower_bound).to_s.strip
        case_values.push Cyto::CaseNr.new(higher_bound).to_s.strip
      else
        case_keys.push "praxistar_eingangsnr = ?"
        case_values.push Cyto::CaseNr.new(case_params[:praxistar_eingangsnr]).to_s.strip
      end
    end
    
    unless case_params[:entry_date].empty?
      if case_params[:entry_date].match /bis/
        lower_bound, higher_bound = case_params[:entry_date].split('bis')
        case_keys.push "entry_date BETWEEN ? AND ?"
        case_values.push parse_date(lower_bound.strip).strip
        case_values.push parse_date(higher_bound.strip).strip
      else
        case_keys.push "entry_date = ? "
        case_values.push parse_date(case_params[:entry_date]).strip
      end
    end
    
    unless case_params[:examination_date].empty?
      if case_params[:examination_date].match /bis/
        lower_bound, higher_bound = case_params[:examination_date].split('bis')
        case_keys.push "examination_date BETWEEN ? AND ?"
        case_values.push parse_date(lower_bound.strip).strip
        case_values.push parse_date(higher_bound.strip).strip
      else
        case_keys.push "examination_date = ? "
        case_values.push parse_date(case_params[:examination_date]).strip
      end
    end
    

    # Handle doctor params
    doctor_params = params[:doctor]
    
    unless doctor_params[:doctor_id].empty?
      case_keys.push "doctor_id = ?"
      case_values.push doctor_params[:doctor_id]
    end
    
    
    # Handle patient params
    patient_params = params[:patient]
    
    unless patient_params[:full_name].empty?
      case_keys.push "patient_id = ?"
      case_values.push patient_params[:full_name].split(' ')[0].strip
    end
    

    # Build conditions array
    case_conditions = [  case_keys.join(" AND "), *case_values ]
    @case_pages, @cases = paginate :cases, :per_page => 20, :conditions => case_conditions
    render :template => '/cyto/cases/list'
  end
end
