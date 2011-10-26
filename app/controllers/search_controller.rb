class SearchController < ApplicationController
  helper :doctors
  auto_complete_for_vcard :vcard
  
  def index
    redirect_to :action => :search_form
  end
  
  def search_form
  end

  include Controller::Search

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
        if param.match /bis|-/
          lower_bound, higher_bound = param.split(/bis|-/)
          keys.push "praxistar_eingangsnr BETWEEN ? AND ?"
          values.push CaseNr.new(lower_bound).to_s.strip
          values.push CaseNr.new(higher_bound).to_s.strip
        else
          keys.push "praxistar_eingangsnr = ?"
          values.push CaseNr.new(param).to_s.strip
        end
      end
    end

    case_keys.push(keys.join(" OR ")) unless keys.empty?
    case_values.push(*values)
    
    # Handle entry_date
    unless case_params[:entry_date].nil? or case_params[:entry_date].empty?
      if case_params[:entry_date].match /bis/
        lower_bound, higher_bound = case_params[:entry_date].split('bis')
        case_keys.push "entry_date BETWEEN ? AND ?"
        case_values.push Date.parse_date(lower_bound.strip)
        case_values.push Date.parse_date(higher_bound.strip)
      else
        case_keys.push "entry_date = ? "
        case_values.push Date.parse_date(case_params[:entry_date])
      end
    end
    
    unless case_params[:printed_at].nil? or case_params[:printed_at].empty?
      if case_params[:printed_at].match /bis/
        lower_bound, higher_bound = case_params[:printed_at].split('bis')
        case_keys.push "result_report_printed_at BETWEEN ? AND ?"
        case_values.push Date.parse_date(lower_bound.strip)
        case_values.push Date.parse_date(higher_bound.strip)
      else
        case_keys.push "result_report_printed_at = ? "
        case_values.push Date.parse_date(case_params[:printed_at])
      end
    end
    
    unless case_params[:screened_at].nil? or case_params[:screened_at].empty?
      if case_params[:screened_at].match /bis/
        lower_bound, higher_bound = case_params[:screened_at].split('bis')
        case_keys.push "screened_at BETWEEN ? AND ?"
        case_values.push Date.parse_date(lower_bound.strip)
        case_values.push Date.parse_date(higher_bound.strip)
      else
        case_keys.push "screened_at = ? "
        case_values.push Date.parse_date(case_params[:screened_at])
      end
    end
    
    unless case_params[:examination_date].nil? or case_params[:examination_date].empty?
      if case_params[:examination_date].match /bis/
        lower_bound, higher_bound = case_params[:examination_date].split('bis')
        case_keys.push "examination_date BETWEEN ? AND ?"
        case_values.push Date.parse_date(lower_bound.strip)
        case_values.push Date.parse_date(higher_bound.strip)
      else
        case_keys.push "examination_date = ? "
        case_values.push Date.parse_date(case_params[:examination_date])
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
    key, *values = patient_conditions

    case_keys.push key
    case_values.push *values
    
    # Handle patient vcard params
    key, *values = vcard_conditions
    
    case_keys.push key
    case_values.push *values

    # Build conditions array
    if case_keys.compact.empty?
      @cases = []
    else
      case_conditions = [ case_keys.compact.join(" AND "), *case_values ]
      @cases = Case.paginate(:page => params['page'], :select => 'DISTINCT cases.*', :joins => "LEFT JOIN patients ON patient_id = patients.id LEFT JOIN vcards ON (patients.id = vcards.object_id AND vcards.object_type = 'Patient') LEFT JOIN addresses ON vcards.id = addresses.vcard_id", :conditions => case_conditions, :per_page => 100)
    end
    
    @include_bill = true
    render :partial => 'cases/list'
  end
end
