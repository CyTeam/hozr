include Cyto

class SearchController < ApplicationController
  helper :doctors
  auto_complete_for_vcard :vcard
  
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
  
  def free_search
    query = params[:query]
  
    conditions = query.split('AND')
    params[:case] ||= {}
    params[:doctor] ||= {}
    for condition in conditions
      field, value = condition.strip.split(':')
      
      # We don't need no spaces here
      value.strip
      case field
      when 'nr'
        params[:case][:praxistar_eingangsnr] = value
      when 'eingang', 'eing', 'ed'
        params[:case][:entry_date] = value
      when 'abstrich', 'abstr', 'ex', 'ad'
       params[:case][:examination_date] = value
      when 'druck', 'dd', 'pa'
       params[:case][:printed_at] = value
      when 'arzt', 'ai', 'di'
       params[:doctor][:doctor_id] = value
      end
    end
    
    search
  end
  
  def vcard_search
    vcard_params = params[:vcard] || {}
    keys = []
    values = []
    
    fields = vcard_params.reject { |key, value| value.nil? or value.empty? }
    fields.each { |key, value|
      keys.push "#{key} LIKE ?"
      values.push '%' + value.downcase.gsub(' ', '%') + '%'
    }
    
    conditions = !keys.empty? ? [ keys.join(" AND "), *values ] : nil
    if conditions.nil?
      return nil
    else
      return conditions
    end
  end

  def search
    # Use key and value arrays to build contitions
    case_keys = []
    case_values = []
    keys = []
    values = []

    # Handle case params
    case_params = params[:case] || {}

    # Handle praxistar_eingangsnr
    all_params = case_params[:praxistar_eingangsnr]
    unless all_params.nil? or all_params.empty?
      for param in all_params.split(',').map {|v| v.strip}
        if param.match /bis/
          lower_bound, higher_bound = param.split('bis')
          keys.push "praxistar_eingangsnr BETWEEN ? AND ?"
          values.push Cyto::CaseNr.new(lower_bound).to_s.strip
          values.push Cyto::CaseNr.new(higher_bound).to_s.strip
        else
          keys.push "praxistar_eingangsnr = ?"
          values.push Cyto::CaseNr.new(param).to_s.strip
        end
      end
    end
    case_keys.push(keys.join(" OR "))
    case_values.push(*values)

    # Handle entry_date
    unless case_params[:entry_date].nil? or case_params[:entry_date].empty?
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
    
    unless case_params[:printed_at].nil? or case_params[:printed_at].empty?
      if case_params[:printed_at].match /bis/
        lower_bound, higher_bound = case_params[:printed_at].split('bis')
        case_keys.push "result_report_printed_at BETWEEN ? AND ?"
        case_values.push parse_date(lower_bound.strip).strip
        case_values.push parse_date(higher_bound.strip).strip
      else
        case_keys.push "result_report_printed_at = ? "
        case_values.push parse_date(case_params[:printed_at]).strip
      end
    end
    
    unless case_params[:screened_at].nil? or case_params[:screened_at].empty?
      if case_params[:screened_at].match /bis/
        lower_bound, higher_bound = case_params[:screened_at].split('bis')
        case_keys.push "screened_at BETWEEN ? AND ?"
        case_values.push parse_date(lower_bound.strip).strip
        case_values.push parse_date(higher_bound.strip).strip
      else
        case_keys.push "screened_at = ? "
        case_values.push parse_date(case_params[:screened_at]).strip
      end
    end
    
    unless case_params[:examination_date].nil? or case_params[:examination_date].empty?
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
    
    unless case_params[:screener_id].nil? or case_params[:screener_id].empty?
      case_keys.push "screener_id = ?"
      case_values.push case_params[:screener_id]
    end
    
    # Handle doctor params
    doctor_params = params[:doctor] || {}
    
    unless doctor_params[:doctor_id].nil? or doctor_params[:doctor_id].empty?
      case_keys.push "cases.doctor_id = ?"
      case_values.push doctor_params[:doctor_id]
    end
    
    
    # Handle patient params
    patient_params = params[:patient] || {}
    patient_keys = case_keys
    patient_values = case_values
    
    unless patient_params[:full_name].nil? or patient_params[:full_name].empty?
      case_keys.push "patient_id = ?"
      case_values.push patient_params[:full_name].split(' ')[0].strip
    end
    
    unless patient_params[:birth_date].nil? or patient_params[:birth_date].empty?
      if patient_params[:birth_date].match /bis/
        lower_bound, higher_bound = patient_params[:birth_date].split('bis')
        patient_keys.push "birth_date BETWEEN ? AND ?"
        patient_values.push parse_date(lower_bound.strip).strip
        patient_values.push parse_date(higher_bound.strip).strip
      else
        patient_keys.push "birth_date = ? "
        patient_values.push parse_date(patient_params[:birth_date]).strip
      end
    end
    
    # Handle patient vcard params
    key, *values = vcard_search
    
    case_keys.push key
    case_values.push *values
    
    
    # Build conditions array
    case_conditions = !case_keys.compact.empty? ? [  case_keys.compact.join(" AND "), *case_values ] : nil
    
    @cases = Case.find :all, :select => 'DISTINCT cases.*', :joins => "LEFT JOIN patients ON patient_id = patients.id LEFT JOIN vcards ON (patients.vcard_id = vcards.id OR patients.billing_vcard_id = vcards.id) LEFT JOIN addresses ON vcards.id = addresses.vcard_id", :conditions => case_conditions, :limit => 100
    
    render :partial => '/cyto/cases/list'
  end
end
