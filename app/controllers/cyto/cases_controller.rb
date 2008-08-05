require "net/http"

include Cyto
class Cyto::CasesController < ApplicationController
  # Helpers
  # =======
  helper :doctors
  verify :method => :post, :only => [ :destroy, :create, :update ],
         :redirect_to => { :action => :list }

  # Tiny MCE
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

  # Auto Completion
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


  # Navigation
  # ==========
  def index
    list
    render :action => 'list'
  end

  def search
    conditions = {:sql => [], :params => []}
    if params[:case_search][:doctor_id] > ""
      conditions[:sql]<< "doctor_id = ?"
      conditions[:params]<< params[:case_search][:doctor_id].to_i
    end
    if params[:case_search][:praxistar_eingangsnr] > ""
      conditions[:sql]<< "id = ?"
      conditions[:params]<< Cyto::Case.find_by_praxistar_eingangsnr(Cyto::CaseNr.new(params[:case_search][:praxistar_eingangsnr]).to_s).id || 0
    end

    @case_pages, @cases = paginate 'Cyto::Cases', :per_page => 144, :conditions =>  [ conditions[:sql].join(" AND "), conditions[:params] ]

    render :action => :list
  end

  def history
    @case = Cyto::Case.find(params[:id])
    redirect_to :controller => '/patients', :action => 'show', :id => @case.patient
  end

  def list
    params[:order] ||= 'praxistar_eingangsnr'

    @case_pages, @cases = paginate 'Cyto::Cases', :per_page => 144, :order => params[:order]
  end

  # Assigning
  # =========
  def unassigned_form
    @first_case = Cyto::Case.find(:first, :conditions => 'assigned_at IS NULL' )
    @case_count = Cyto::Case.count(:all, :conditions => 'assigned_at IS NULL' )
  end

  def unassigned_sort_queue
    @cases = Cyto::Case.find(:all, :conditions => 'assigned_at IS NULL')
    @intra_day_id = params[:case][:intra_day_id].to_i
  end

  def assign
    assigned_at = DateTime.now

    case_ids = params[:a_case].keys
    @cases = Cyto::Case.find(case_ids, :order => 'intra_day_id' )

    for a_case in @cases
      a_case.assigned_at = assigned_at
      a_case.update_attributes(params[:a_case][a_case.id.to_s])
      a_case.save!
    end
  end

  def assign_list
    @cases = Cyto::Case.find(:all, :conditions => ['assigned_at = ?', params[:assigned_at]], :order => 'intra_day_id' )

    render :action => 'assign'
  end

  def destroy_from_assign
   Cyto::Case.find(params[:id]).destroy
   render :text => 'gelöscht'
  end
  
  # Show list of assignings from the last 7 days.
  def assignings_list
    @assignings = Cyto::Case.find_by_sql('SELECT assigned_at, min(intra_day_id) AS min_intra_day_id, max(intra_day_id) AS max_intra_day_id, min(praxistar_eingangsnr) AS min_praxistar_eingangsnr, max(praxistar_eingangsnr) AS max_praxistar_eingangsnr, count(*) AS count FROM cases GROUP BY assigned_at HAVING assigned_at > now() - INTERVAL 7 DAY ORDER BY assigned_at DESC')
  end

  # First Entry
  # ===========
  def first_entry_queue
    params[:order] ||= 'praxistar_eingangsnr'

    @case_pages, @cases = paginate 'Cyto::Cases', :per_page => 144, :order => params[:order], :conditions => 'entry_date IS NULL AND assigned_at IS NOT NULL'
    render :action => :list
  end

  def get_patient_by_eingangsnr
    patient = Cyto::Case.find_by_praxistar_eingangsnr(params[:patient][:praxistar_eingangsnr]).patient

    render :inline => "<td id='patient_id'><%= text_field 'patient', 'full_name', :value => '#{patient.id} #{patient.vcard.full_name}' %></td>"
  end

  def first_entry
    @case = Cyto::Case.find(params[:id])

    # Header image size preferences
    @header_image_type = session[:header_image_type] || :head
  end

  def set_patient
    @case = Cyto::Case.find(params[:id])
    # Set entry_date only when setting patient for first time
    @case.entry_date = Time.now if @case.entry_date.nil?
    @case.examination_method_id = @case.intra_day_id == 0 ? 0 : 1

      if params[:patient_id]
        @patient = Patient.find(params[:patient_id])
        @patient.create_billing_vcard if @patient.billing_vcard.nil?
      else
        @patient = Patient.new(params[:patient])
        @patient.vcard = Vcard.new(params[:vcard])
        @patient.billing_vcard = Vcard.new(params[:billing_vcard])

        @patient.save
      end

      @vcard = @patient.vcard
      @billing_vcard = @patient.billing_vcard

    # Copy&Paste from patients_controller

    params[:patient][:sex] = HonorificPrefix.find_by_name(params[:vcard][:honorific_prefix]).sex

    if @vcard.update_attributes(params[:vcard]) and @billing_vcard.update_attributes(params[:billing_vcard]) and @patient.update_attributes(params[:patient])
      @vcard.save
      @billing_vcard.save
      @patient.save
      flash[:notice] = 'Patient was successfully updated.'
#      redirect_to :action => 'list'
    else
      flash[:error] = "Couldn't update Patient."
#      render :action => 'edit'
    end
    # END Copy&Paste

      patient = @patient
      patient.doctor = @case.doctor
      patient.doctor_patient_nr = params[:patient][:doctor_patient_nr] unless params[:patient][:doctor_patient_nr].nil?
      patient.save

      @case.patient = patient

      @case.insurance = @case.patient.insurance
      @case.insurance_nr = @case.patient.insurance_nr

    @case.first_entry_at ||= Time.now
    @case.first_entry_by = Employee.find_by_code(request.env['REMOTE_USER'])
                  
    if @case.save
      flash[:notice] = 'First entry ok.'

      next_open = Cyto::Case.find :first, :conditions => ["entry_date IS NULL and id > #{@case.id}"]
      if next_open.nil?
        redirect_to :action => 'first_entry_queue'
      elsif next_open.praxistar_eingangsnr.nil? or next_open.doctor.nil?
        redirect_to :action => 'unassigned_form'
      else
        redirect_to :action => 'first_entry', :id => next_open
      end
    else
      flash[:error] = 'Ersteingabe erzeugte Fehler.'
      render :action => 'first_entry'
    end
  end

  def create
    params[:case][:patient_id] = params[:patient][:full_name].split(' ')[0].to_i
    @case = Cyto::Case.new(params[:case])

    if @case.save
      flash[:notice] = 'Case was successfully created.'
      redirect_to :action => 'list'
    else
      render :action => 'new'
    end
  end


  # Second Entry
  # ============
  def second_entry_queue
    params[:order] ||= 'praxistar_eingangsnr'

    @case_pages, @cases = paginate 'Cyto::Cases', :per_page => 144, :order => params[:order], :conditions => "entry_date IS NOT NULL AND screened_at IS NULL AND (needs_p16 = '#{Case.connection.false}' AND needs_hpv = '#{Case.connection.false}') AND praxistar_eingangsnr > '07' AND praxistar_eingangsnr < '90' AND NOT praxistar_eingangsnr LIKE '%-%'"
    render :action => :list
  end

  def second_entry_pap_form
    @case = Cyto::Case.find(params[:id])
  end

  def second_entry_form
    @case = Cyto::Case.find(params[:id])

    if @case.finding_text.nil?
      @case.finding_text = @case.findings.map {|finding| "<div>#{finding.name}</div>"}.join("\n")
      @case.save
    end

    if params[:case] && params[:case][:classification]
      classification = Cyto::Classification.find(params[:case][:classification])
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
    @case = Cyto::Case.find(params[:id])

    @case.screener = Employee.find_by_code(request.env['REMOTE_USER'])
    @case.remarks = params[:case][:remarks]

    case params[:commit]
    when "Erstellen"
      @case.save
      redirect_to :action => 'result_report', :id => @case
      # That's it if it's a normal PAP
      return
    when "P16+HPV"
      @case.needs_hpv = true
      @case.needs_p16 = true
    when "P16"
      @case.needs_p16 = true
    when "Review"
      @case = Cyto::Case.find(params[:id])
      @case.screened_at = Time.now
      @case.screener = Employee.find_by_code(request.env['REMOTE_USER'])
      @case.needs_review = true
    end

    # Common code for hpv, p16 and review.
    @case.save

    next_open = Cyto::Case.find :first, :conditions => ["entry_date IS NOT NULL AND screened_at IS NULL AND (needs_p16 = '#{Case.connection.false}' AND needs_hpv = '#{Case.connection.false}') AND praxistar_eingangsnr > ? AND praxistar_eingangsnr < '90/'", @case.praxistar_eingangsnr]
    if next_open.nil?
      redirect_to :action => 'second_entry_queue'
    else
      redirect_to :action => 'second_entry_pap_form', :id => next_open
    end
  end

  def remove_finding
    @case = Cyto::Case.find(params[:id])

    finding = FindingClass.find(params[:finding_id])
    @case.finding_classes.delete(finding)
    @case.finding_text.gsub! "<div>#{finding.name}</div>", ''

    @case.save

    render :partial => '/cyto/finding_classes/list_findings'
  end

  def add_finding
    @case = Cyto::Case.find(params[:id])

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

  def update_finding_text
    @case = Cyto::Case.find(params[:id])

    @case.finding_text = params[:case][:finding_text]
    @case.save

    render :partial => 'list_findings'
  end

  def edit_finding_text
    @case = Cyto::Case.find(params[:id])

    render :partial => 'edit_finding_text'
  end

  def sign
    @case = Cyto::Case.find(params[:id])
    @case.screened_at = Time.now
    @case.screener = Employee.find_by_code(request.env['REMOTE_USER'])
    @case.finding_text = params[:case][:finding_text] unless params[:case].nil? or params[:case][:finding_text].nil?

    # Check if case needs review
    low_classifications = ['1', '2']
    high_classifications = ['3M', '3S', '3M-c1-2', '3S-c2-3', '4', '5']

    previous_case = @case.patient.cases[1]
    if previous_case
      # Sudden jump from PAP I/II to CIN I-II and higher
      low_to_high = (low_classifications.include?(previous_case.classification.code) and high_classifications.include?(@case.classification.code))
      high_to_low = (high_classifications.include?(previous_case.classification.code) and low_classifications.include?(@case.classification.code))
    end
      
    # Higher than Cin I-II
    high = high_classifications.include?(@case.classification.code)

    @case.needs_review = (low_to_high or high_to_low or high)

    # Save
    @case.save

    if @case.needs_p16? or @case.needs_hpv?
      next_open = Cyto::Case.find :first, :conditions => ["entry_date IS NOT NULL AND screened_at IS NULL AND (needs_p16 = '#{Case.connection.true}' OR needs_hpv = '#{Case.connection.true}') AND screener_id = ? AND praxistar_eingangsnr > ? AND praxistar_eingangsnr < '90/'", @case.screener_id, @case.praxistar_eingangsnr]

      @case.result_report_printed_at = nil
      @case.save

      if next_open.nil?
        redirect_to :action => 'hpv_p16_queue'
      else
#        redirect_to :action => 'second_entry_pap_form', :id => next_open
        redirect_to :action => 'hpv_p16_queue'
      end
    else
      next_open = Cyto::Case.find :first, :conditions => ["entry_date IS NOT NULL AND screened_at IS NULL AND (needs_p16 = '#{Case.connection.false}' AND needs_hpv = '#{Case.connection.false}') AND praxistar_eingangsnr > ? AND praxistar_eingangsnr < '90/'", @case.praxistar_eingangsnr]
      if next_open.nil?
        redirect_to :action => 'second_entry_queue'
      else
        redirect_to :action => 'second_entry_pap_form', :id => next_open
      end
    end
  end

  # Review Queue
  # ============
  def review_queue
    params[:order] ||= 'praxistar_eingangsnr'
    
    @case_pages, @cases = paginate 'Cyto::Cases', :per_page => 144, :order => params[:order], :conditions => [ "needs_review = ?", true ]
    render :action => :list
  end

  def review_done
    @case = Cyto::Case.find(params[:id])
    @case.needs_review = false
    
    @case.review_by = Employee.find_by_code(request.env['REMOTE_USER'])
    @case.review_at = Time.now
    
    @case.save!
    
    redirect_to :action => :review_queue
  end
  
  # Results
  # =======
  def result_report
    @case = Cyto::Case.find(params[:id])
    @case.screened_at ||= Date.today

    case @case.classification.code
    when 'mam', 'sput'
      render :action => :eg_result_report
    else
      render :action => :result_report
    end
  end

  def result_report_for_pdf
    @case = Cyto::Case.find(params[:id])

    if @case.screened_at.nil? and @case.needs_p16?
      @case.screened_at ||= Date.today
      render :action => :p16_notice_report, :layout => 'result_report_for_pdf'
      return
    end

    @case.screened_at ||= Date.today

    case @case.classification.code
    when 'mam'
      render :action => :eg_result_report_for_pdf, :layout => 'result_report_for_pdf'
    else
      render :action => :result_report, :layout => 'result_report_for_pdf'
    end
  end

  def result_letter
    @doctor = Doctor.find(params[:id])
  end

  def result_letter_for_pdf
    @doctor = Doctor.find(params[:id])

    render :action => 'result_letter', :layout => 'result_letter_for_pdf'
  end


  # Printing
  # ========
  def print_result_report
    ids = params[:id] ? params[:id] : params[:ids].split('/')
    output = "<pre>"
    for id in ids
      stream = open("|/usr/local/bin/hozr_print_result_report.sh #{id} --force #{(ENV['RAILS_ENV'] || 'development')} 2>&1")
      output += stream.read
    end

    output += "</pre>"
    send_data output, :type => 'text/html; charset=utf-8', :disposition => 'inline'
  end

  def print_result_report_as_fax
    ids = params[:id] ? params[:id] : params[:ids].split('/')
    output = "<pre>"
    for id in ids
      stream = open("|/usr/local/bin/hozr_print_result_report.sh #{id} --fax --force '#{id}' #{(ENV['RAILS_ENV'] || 'development')} 2>&1")
      output += stream.read
    end

    output += "</pre>"
    send_data output, :type => 'text/html; charset=utf-8', :disposition => 'inline'
  end


  # P16/HPV
  # =======
  def hpv_p16_queue
    params[:order] ||= 'praxistar_eingangsnr'

    @case_pages, @cases = paginate 'Cyto::Cases', :per_page => 144, :order => params[:order], :conditions => ["(needs_p16 = ? OR needs_hpv = ?) AND screened_at IS NULL", true, true]
    render :action => :list
  end

  def hpv_p16_prepared
    a_case = Cyto::Case.find(params[:id])
    a_case.hpv_p16_prepared_at = DateTime.now
    a_case.hpv_p16_prepared_by = Employee.find_by_code(request.env['REMOTE_USER'])
    a_case.save

    render :text => "#{a_case.hpv_p16_prepared_at.strftime('%d.%m.%Y')} #{a_case.hpv_p16_prepared_by.nil? ? "" : a_case.hpv_p16_prepared_by.code}"
  end

  # Create a new HPV/P16 case after a case has been closed
  def create_hpv_p16_for_case
    @case = Cyto::Case.find(params[:id])

    # Clone the case and set columns
    hpv = @case.clone
    hpv.praxistar_eingangsnr = Cyto::CaseNr.new.to_s
    hpv.screened_at = nil
    hpv.praxistar_leistungsblatt_id = nil
    hpv.result_report_printed_at = nil
    hpv.finding_classes = []
    hpv.finding_text = ""

    hpv.needs_p16 = true
    hpv.needs_hpv = true
    hpv.classification = Cyto::Classification.find :first, :conditions => "code = 'hpv' AND examination_method_id = #{hpv.examination_method_id}"
    hpv.save

    redirect_to :controller => '/search'
  end


  # General
  # =======
  def show
    @case = Cyto::Case.find(params[:id])
  end

  def new
    redirect_to :controller => '/cyto/order_forms', :action => 'new'
  end

  def edit
    @case = Cyto::Case.find(params[:id])
  end

  def update
    @case = Cyto::Case.find(params[:id])
    if @case.update_attributes(params[:case])
      flash[:notice] = 'Case was successfully updated.'
      redirect_to :action => 'show', :id => @case
    else
      render :action => 'edit'
    end
  end

  def destroy
   Cyto::Case.find(params[:id]).destroy
    redirect_to :action => 'list'
  end
end
