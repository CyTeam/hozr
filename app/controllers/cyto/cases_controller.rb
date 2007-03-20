require "net/http"

include Cyto

class Cyto::CasesController < ApplicationController
  helper :doctors
  
  uses_tiny_mce(:options => {:theme => 'advanced',
                           :browsers => %w{msie gecko},
                           :theme_advanced_toolbar_location => "top",
                           :theme_advanced_toolbar_align => "left",
                           :theme_advanced_resizing => true,
                           :theme_advanced_resize_horizontal => false,
                           :theme_advanced_buttons1 => %w{bold italic underline separator indent outdent separator bullist forecolor backcolor separator undo redo},
                           :theme_advanced_buttons2 => [],
                           :theme_advanced_buttons3 => []},
              :only => [:new, :edit, :show, :index, :result_report, :second_entry_form])

  auto_complete_for :finding_class, :selection, :limit => 12
#  auto_complete_for :patient, :family_name, :joins => "JOIN vcards ON patients.vcard_id = vcards.id", :limit => 12
  
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
    
  def auto_complete_for_finding_class_selection
    @finding_classes = FindingClass.find(:all, 
      :conditions => [ FindingClass.connection.concat(:code, ' - ', :name) + " LIKE ?",
      '%' + params[:finding_class][:selection].downcase + '%' ],
      :select => "*, #{FindingClass.connection.concat(:code, ' - ', :name)} AS selection",
      :order => 'code',
      :limit => 8)
    render :inline => "<%= auto_complete_result_finding_class_selection @finding_classes, 'code' %>"
  end
    
  def auto_complete_for_patient_family_name
     find_options = { 
       :conditions => [ "LOWER(family_name) LIKE ?", '%' + params[:patient][:family_name].downcase + '%' ],
       :order => "family_name ASC",
       :select => "patients.*",
       :joins => "JOIN vcards ON patients.vcard_id = vcards.id",
       :limit => 30}

       @items = Patient.find(:all, find_options)
       render :inline => "<%= auto_complete_result_patient @items, 'family_name' %>"
  end
  
  def index
    list
    render :action => 'list'
  end

  # GETs should be safe (see http://www.w3.org/2001/tag/doc/whenToUseGet.html)
  verify :method => :post, :only => [ :destroy, :create, :update ],
         :redirect_to => { :action => :list }

  def search
    conditions = {:sql => [], :params => []}
    if params[:case_search][:doctor_id] > ""
      conditions[:sql]<< "doctor_id = ?"
      conditions[:params]<< params[:case_search][:doctor_id].to_i
    end
    if params[:case_search][:praxistar_eingangsnr] > ""
      conditions[:sql]<< "id = ?"
      conditions[:params]<< Case.find_by_praxistar_eingangsnr(Cyto::CaseNr.new(params[:case_search][:praxistar_eingangsnr]).to_s).id || 0
    end
    
    @case_pages, @cases = paginate :cases, :per_page => 144, :conditions =>  [ conditions[:sql].join(" AND "), conditions[:params] ]
  
    render :action => :list
  end
  
  def history
    @case = Case.find(params[:id])
    redirect_to :controller => '/patients', :action => 'show', :id => @case.patient
  end
  
  def list
    params[:order] ||= 'praxistar_eingangsnr'
    
    @case_pages, @cases = paginate :cases, :per_page => 144, :order => params[:order]
  end

  def p16_queue
    params[:order] ||= 'praxistar_eingangsnr'
    
    @case_pages, @cases = paginate :cases, :per_page => 144, :order => params[:order], :conditions => "(needs_p16 = #{Case.connection.true}) AND screened_at IS NULL"
    render :action => :list
  end
  
  def hpv_queue
    params[:order] ||= 'praxistar_eingangsnr'
    
    @case_pages, @cases = paginate :cases, :per_page => 144, :order => params[:order], :include => :classification, :conditions => "(classifications.code = 'hpv') AND screened_at IS NULL"
    render :action => :list
  end
  
  def first_entry_queue
    params[:order] ||= 'praxistar_eingangsnr'
    
    @case_pages, @cases = paginate :cases, :per_page => 144, :order => params[:order], :conditions => 'entry_date IS NULL'
    render :action => :list
  end
  
  def second_entry_queue
    params[:order] ||= 'praxistar_eingangsnr'
    
    @case_pages, @cases = paginate :cases, :per_page => 144, :order => params[:order], :conditions => "entry_date IS NOT NULL AND screened_at IS NULL AND (needs_p16 = 'f' OR needs_p16 = 0) AND praxistar_eingangsnr > '07' AND praxistar_eingangsnr < '90' AND NOT praxistar_eingangsnr LIKE '%-%'"
    render :action => :list
  end
  
  def show
    @case = Case.find(params[:id])
  end

  def new
    redirect_to :controller => '/cyto/order_forms', :action => 'new'
  end

  def get_patient_by_eingangsnr
    patient = Case.find_by_praxistar_eingangsnr(params[:patient][:praxistar_eingangsnr]).patient
    render :inline => "<td id='patient_id'><%= text_field 'patient', 'full_name', :value => '#{patient.id} #{patient.vcard.full_name}' %></td>"
  end
  
  def first_entry
    @case = Case.find(params[:id])
  
    session[:first_entry] = {} if session[:first_entry].nil?
    
    # Preseed some fields
    @case.doctor_id = session[:first_entry][:doctor_id]
    @case.praxistar_eingangsnr = Cyto::CaseNr.next(session[:first_entry][:praxistar_eingangsnr]).to_s
    @case.examination_method_id = 1
  end

  def first_entry_update
    # save fields in session for preseeding
    session[:first_entry][:doctor_id] = params[:case][:doctor_id]
    session[:first_entry][:praxistar_eingangsnr] = params[:case][:praxistar_eingangsnr]
    
    params[:case][:entry_date] = Time.now
    
    @case = Case.find(params[:id])
    @case.update_attributes(params[:case])
    
    begin
      patient = Patient.find(params[:patient][:full_name].split(' ')[0].to_i)
      patient.doctor = @case.doctor
      patient.doctor_patient_nr = params[:patient][:doctor_patient_nr] unless params[:patient][:doctor_patient_nr].nil?
      patient.save
      
      @case.patient = patient
    
      @case.insurance = @case.patient.insurance
      @case.insurance_nr = @case.patient.insurance_nr
    rescue
      @case.errors.add('patient_id', 'Patient not found.')
    end
    
    if @case.save
      flash[:notice] = 'First entry ok.'
      
      next_open = Case.find :first, :conditions => ["entry_date IS NULL and id > #{@case.id}"]
      if next_open.nil?
        redirect_to :action => 'first_entry_queue'
      else
        redirect_to :action => 'first_entry', :id => next_open
      end
    else
      render :action => 'first_entry'
    end
  end
  
  def create
    params[:case][:patient_id] = params[:patient][:full_name].split(' ')[0].to_i
    @case = Case.new(params[:case])
    
    if @case.save
      flash[:notice] = 'Case was successfully created.'
      redirect_to :action => 'list'
    else
      render :action => 'new'
    end
  end

  def second_entry_pap_form
    @case = Case.find(params[:id])
  end
  
  def second_entry_form
    @case = Case.find(params[:id])
    
    if @case.finding_text.nil?
      @case.finding_text = @case.findings.map {|finding| "<div>#{finding.name}</div>"}.join("\n")
      @case.save
    end

    if params[:case] && params[:case][:classification]
      classification = Classification.find(params[:case][:classification])
      @case.classification = classification
      @case.save
    end
    
    case @case.classification.code
    when '2A', '2-3A'
      render :action => 'second_entry_agus_ascus_form'
    when 'mam', 'sput'
      @case.screened_at ||= Date.today
      @case.screener = Employee.find_by_code(request.env['REMOTE_USER'])
      render :action => 'eg_result_report'
    end
  end
  
  def second_entry_update
    @case = Case.find(params[:id])
    
    @case.screener = Employee.find_by_code(request.env['REMOTE_USER'])
    @case.remarks = params[:case][:remarks]
    @case.save

    case params[:commit]
    when "Erstellen"
      @case.screened_at ||= Date.today
    when "HPV"
      @case.screened_at ||= Date.today
      
      hpv = @case.clone
      hpv.praxistar_eingangsnr = @case.praxistar_eingangsnr.gsub /\//, '-'
      hpv.screened_at = nil
      hpv.praxistar_leistungsblatt_id = nil
      hpv.result_report_printed_at = nil
      hpv.needs_p16 = false
      hpv.classification = Classification.find :first, :conditions => "code = 'hpv' AND examination_method_id = #{hpv.examination_method_id}"
      hpv.save
    when "P16"
      @case.needs_p16 = true
      @case.save
      redirect_to :action => 'second_entry_queue'
      return
    end
  
    redirect_to :action => 'result_report', :id => @case
  end
  
  def result_report
    @case = Case.find(params[:id])
    @case.screened_at ||= Date.today
  
    case @case.classification.code
    when 'mam', 'sput'
      render :action => :eg_result_report
    when 'hpv'
      render :action => :hpv_result_report
    else
      render :action => :result_report
    end
  end
  
  def result_report_for_pdf
    @case = Case.find(params[:id])
    @case.screened_at ||= Date.today
    
    case @case.classification.code
    when 'mam', 'sput'
      render :action => :eg_result_report_for_pdf, :layout => 'result_report_for_pdf'
    when 'hpv'
      render :action => :hpv_result_report, :layout => 'result_report_for_pdf'
    else
      render :action => :result_report, :layout => 'result_report_for_pdf'
    end
  end
  
  def result_report_pdf
    h = Net::HTTP.new('localhost', 80)
    h.open_timeout = 30  # secs
    h.read_timeout = 120  # secs

    resp, data = h.get("/~shuerlimann/html2ps_v213_dev/public_html/demo/html2ps.php?process_mode=single&URL=http%3A%2F%2Flocalhost%3A3000%2Fcyto%2Fcases%2Fresult_report_for_pdf%2F#{params[:id]}&pixels=570&scalepoints=1&renderimages=1&renderlinks=0&media=A5&cssmedia=print&leftmargin=0&rightmargin=0&topmargin=0&bottommargin=0&pslevel=3&method=fpdf&pdfversion=1.3&output=0&convert=Convert+File", nil)
    
    aFile = File.new("public/testfile", 'w')
    aFile.print(data)
    aFile.close
  end
  
  def sign
    @case = Case.find(params[:id])
    @case.screened_at = Time.now
    @case.screener = Employee.find_by_code(request.env['REMOTE_USER'])
    @case.finding_text = params[:case][:finding_text] unless params[:case].nil? or params[:case][:finding_text].nil?
    @case.save
  
    if @case.needs_p16?
      next_open = Case.find :first, :conditions => ["entry_date IS NOT NULL AND screened_at IS NULL AND needs_p16 = '1' AND screener_id = ? AND praxistar_eingangsnr > ? AND praxistar_eingangsnr < '90/'", @case.screener_id, @case.praxistar_eingangsnr]
      
      if next_open.nil?
        redirect_to :action => 'p16_queue'
      else
#        redirect_to :action => 'second_entry_pap_form', :id => next_open
        redirect_to :action => 'p16_queue'
      end
    else
      next_open = Case.find :first, :conditions => ["entry_date IS NOT NULL AND screened_at IS NULL AND needs_p16 = '0' AND praxistar_eingangsnr > ? AND praxistar_eingangsnr < '90/'", @case.praxistar_eingangsnr]
      if next_open.nil?
        redirect_to :action => 'second_entry_queue'
      else
        redirect_to :action => 'second_entry_pap_form', :id => next_open
      end
    end
  end
  
  def remove_finding
    @case = Case.find(params[:id])

    finding = FindingClass.find(params[:finding_id])
    @case.finding_classes.delete(finding)
    @case.finding_text.gsub! "<div>#{finding.name}</div>", ''

    @case.save
    
    render :partial => '/cyto/finding_classes/list_findings'
  end
    
  def add_finding
    @case = Case.find(params[:id])
    
    begin
      if params[:finding_id]
        finding_class_id = params[:finding_id]
        finding_class = FindingClass.find(finding_class_id)
      elsif params[:finding_class][:selection] > ''
        finding_class_code = params[:finding_class][:selection].split(' - ')[0]
        finding_class = FindingClass.find_by_code(finding_class_code)
      elsif params[:finding_class][:code]
        finding_class_code = params[:finding_class][:code]
        finding_class = FindingClass.find_by_code(finding_class_code)
      end
      
      @case.finding_classes << finding_class
      @case.finding_text = '' if @case.finding_text.nil?
      @case.finding_text += "<div>#{finding_class.name}</div>" unless finding_class.belongs_to_group?('Zustand') || finding_class.belongs_to_group?('Kontrolle')
      
      @case.save
      
    rescue ActiveRecord::AssociationTypeMismatch
      flash.now[:error] = "Unbekannter Code: #{finding_class_code}"
    
    rescue ActiveRecord::StatementInvalid
      flash.now[:error] = "Code bereits eingegeben"
    end
    
    render :partial => '/cyto/finding_classes/list_findings'
  end

  def edit
    @case = Case.find(params[:id])
  end

  def update
    @case = Case.find(params[:id])
    if @case.update_attributes(params[:case])
      flash[:notice] = 'Case was successfully updated.'
      redirect_to :action => 'show', :id => @case
    else
      render :action => 'edit'
    end
  end

  def destroy
    Case.find(params[:id]).destroy
    redirect_to :action => 'list'
  end

  def result_letter
    @doctor = Doctor.find(params[:id])
  end

  def result_letter_for_pdf
    @doctor = Doctor.find(params[:id])

    render :action => 'result_letter', :layout => 'result_letter_for_pdf'
  end

  def update_finding_text
    @case = Case.find(params[:id])
    
    @case.finding_text = params[:case][:finding_text]
    @case.save
  
    render :partial => 'list_findings'
  end
  
  def edit_finding_text
    @case = Case.find(params[:id])
    
    render :partial => 'edit_finding_text'
  end
  
  def unassigned_form
  end
  
  def unassigned_sort_queue
    @cases = Case.find(:all, :conditions => 'assigned_at IS NULL' )
    @intra_day_id = params[:case][:intra_day_id].to_i
  end
  
  def unassigned_queue
    case_ids = params[:a_case].keys
    for case_id in case_ids
      a_case = Case.find(case_id)
      a_case.update_attributes(params[:a_case][case_id])
      a_case.save!
    end
    
    @cases = Case.find(:all, :conditions => 'assigned_at IS NULL', :order => 'intra_day_id' )
  end

  def assign
    cases = Case.find(:all, :conditions => 'assigned_at IS NULL', :order => 'intra_day_id' )
  
    case_ids = cases.map {|a_case| a_case.id }
    
    doctor_id = nil
    for case_id in case_ids
      a_case = Case.find(case_id)
      unless params[:a_case][case_id.to_s][:doctor_id].nil? or params[:a_case][case_id.to_s][:doctor_id].empty?
        doctor_id = params[:a_case][case_id.to_s][:doctor_id]
      end
      
      params[:a_case][case_id.to_s][:doctor_id] = doctor_id
      a_case.update_attributes(params[:a_case][case_id.to_s])
      a_case.save!
    end
    
    @cases = Case.find(:all, :conditions => 'assigned_at IS NULL', :order => 'intra_day_id' )
  end
end
