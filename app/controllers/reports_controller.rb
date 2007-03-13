class ReportsController < ApplicationController
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

  # To make caching easier, add a line like this to config/routes.rb:
  # map.graph "graph/:action/:id/image.png", :controller => "graph"
  #
  # Then reference it with the named route:
  #   image_tag graph_url(:action => 'show', :id => 42)

  def index
    render :action => :report_form
  end
  
  def pap_groups
    @records = ActiveRecord::Base.find_by_sql('SELECT substr(praxistar_eingangsnr, 1, 2) AS year, classifications.name AS pap, count(*) AS count FROM cases JOIN classifications ON cases.classification_id = classifications.id GROUP BY substr(praxistar_eingangsnr, 1, 2), classifications.code ORDER BY substr(praxistar_eingangsnr, 1, 2)')
    
    render :partial => 'statistics'
  end
  
  def search
    @columns = ['Pap', 'Anzahl', 'Prozent']
    
    # only accept known columns, to avoid SQL insertion attacks
    if @columns.include? params[:order] or @columns.map {|col| "#{col} DESC"}.include? params[:order]
      order = params[:order]
    else
      order = 'Pap'
    end
    
    # Use key and value arrays to build contitions
    case_keys = []
    case_values = []
    
    # Handle case params
    case_params = params[:case] || {}
    
    unless case_params[:praxistar_eingangsnr].nil? or case_params[:praxistar_eingangsnr].empty?
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
      case_keys.push "doctor_id = ?"
      case_values.push doctor_params[:doctor_id]
    end
    
    
    # Handle patient params
    patient_params = params[:patient] || {}
    
    unless patient_params[:full_name].nil? or patient_params[:full_name].empty?
      case_keys.push "patient_id = ?"
      case_values.push patient_params[:full_name].split(' ')[0].strip
    end
    
    # Build conditions array
    case_conditions = !case_keys.empty? ? [  case_keys.join(" AND "), *case_values ] : nil
    
    # The following doesn't work 'cause of a known bug: :include overrides :select
    # @records = Cyto::Case.find( :all, :select => "classifications.code AS Pap, count(*) AS Anzahl, count(*)/(SELECT count(*) FROM cases)*100.0 AS Prozent", :include => 'classification', :group => 'classifications.code',  :order => "#{order}")
    
    count = Cyto::Case.find( :all, :conditions => case_conditions).size
    
    @records = Cyto::Case.find( :all, :select => "classifications.name AS Pap, count(*) AS Anzahl, count(*)/#{count}*100.0 AS Prozent", :joins => 'LEFT JOIN classifications ON classification_id = classifications.id', :group => 'classifications.code',  :order => order, :conditions => case_conditions)
    
    render :partial => 'statistics'
  end
  
  def cyto_cases
    g = Gruff::Line.new
    # Uncomment to use your own theme or font
    # See http://colourlovers.com or http://www.firewheeldesign.com/widgets/ for color ideas
#     g.theme = {
#       :colors => ['#663366', '#cccc99', '#cc6633', '#cc9966', '#99cc99'],
#       :marker_color => 'white',
#       :background_colors => ['black', '#333333']
#     }
#     g.font = File.expand_path('artwork/fonts/VeraBd.ttf', RAILS_ROOT)

    g.title = "Anzahl PAP"
    
    g.data("Total", [ Cyto::Case.find( :all, :conditions => "praxistar_eingangsnr > '02/' and praxistar_eingangsnr < '99/' and praxistar_eingangsnr < '03/'").size, Cyto::Case.find( :all, :conditions => "praxistar_eingangsnr > '03/' and praxistar_eingangsnr < '99/' and praxistar_eingangsnr < '04/'").size, Cyto::Case.find( :all, :conditions => "praxistar_eingangsnr > '04/' and praxistar_eingangsnr < '99/' and praxistar_eingangsnr < '05/'").size, Cyto::Case.find( :all, :conditions => "praxistar_eingangsnr > '05/' and praxistar_eingangsnr < '99/' and praxistar_eingangsnr < '06/'").size, Cyto::Case.find( :all, :conditions => "praxistar_eingangsnr > '06/' and praxistar_eingangsnr < '99/' and praxistar_eingangsnr < '07/'").size, Cyto::Case.find( :all, :conditions => "praxistar_eingangsnr > '07/' and praxistar_eingangsnr < '99/' and praxistar_eingangsnr < '08/'").size])

    g.data("PAP I", [ Cyto::Case.find( :all, :conditions => "praxistar_eingangsnr > '02/' and praxistar_eingangsnr < '99/' and praxistar_eingangsnr < '03/' and classification_id = 1").size, Cyto::Case.find( :all, :conditions => "praxistar_eingangsnr > '03/' and praxistar_eingangsnr < '99/' and praxistar_eingangsnr < '04/' and classification_id = 1").size, Cyto::Case.find( :all, :conditions => "praxistar_eingangsnr > '04/' and praxistar_eingangsnr < '99/' and praxistar_eingangsnr < '05/' and classification_id = 1").size, Cyto::Case.find( :all, :conditions => "praxistar_eingangsnr > '05/' and praxistar_eingangsnr < '99/' and praxistar_eingangsnr < '06/' and classification_id = 1").size, Cyto::Case.find( :all, :conditions => "praxistar_eingangsnr > '06/' and praxistar_eingangsnr < '99/' and praxistar_eingangsnr < '07/' and classification_id = 1").size, Cyto::Case.find( :all, :conditions => "praxistar_eingangsnr > '07/' and praxistar_eingangsnr < '99/' and praxistar_eingangsnr < '08/' and classification_id = 1").size])

    g.data("PAP II", [ Cyto::Case.find( :all, :conditions => "praxistar_eingangsnr > '02/' and praxistar_eingangsnr < '99/' and praxistar_eingangsnr < '03/' and classification_id = 2").size, Cyto::Case.find( :all, :conditions => "praxistar_eingangsnr > '03/' and praxistar_eingangsnr < '99/' and praxistar_eingangsnr < '04/' and classification_id = 2").size, Cyto::Case.find( :all, :conditions => "praxistar_eingangsnr > '04/' and praxistar_eingangsnr < '99/' and praxistar_eingangsnr < '05/' and classification_id = 2").size, Cyto::Case.find( :all, :conditions => "praxistar_eingangsnr > '05/' and praxistar_eingangsnr < '99/' and praxistar_eingangsnr < '06/' and classification_id = 2").size, Cyto::Case.find( :all, :conditions => "praxistar_eingangsnr > '06/' and praxistar_eingangsnr < '99/' and praxistar_eingangsnr < '07/' and classification_id = 2").size, Cyto::Case.find( :all, :conditions => "praxistar_eingangsnr > '07/' and praxistar_eingangsnr < '99/' and praxistar_eingangsnr < '08/' and classification_id = 2").size])

    g.labels = {0 => '2002', 1 => '2003', 2 => '2004', 3 => '2005', 4 => '2006', 5 => '2007' }

    send_data(g.to_blob, :disposition => 'inline', :type => 'image/png', :filename => "cyto_cases.png")
  end

end
