include Cyto

class ActiveRecord::ConnectionAdapters::SQLiteAdapter
  def concat(*params)
    params.map { |param|
      case param.class.name
      when 'String'
        quote(param)
      when 'Symbol'
        param.to_s
      end
    }.join(' || ')
  end
end

class ActiveRecord::ConnectionAdapters::MysqlAdapter
  def concat(*params)
    params.map! { |param|
      case param.class.name
      when 'String'
        quote(param)
      when 'Symbol'
        param.to_s
      end
    }

    return "CONCAT( #{params.join(', ')} )"
  end
end

class Cyto::CasesController < ApplicationController
  auto_complete_for :finding_class, :selection, :limit => 12
#  auto_complete_for :patient, :family_name, :joins => "JOIN vcards ON patients.vcard_id = vcards.id", :limit => 12
  
  def auto_complete_for_patient_full_name
    @patients = Patient.find(:all, 
      :conditions => [ Patient.connection.concat(:family_name, ' ', :given_name) + " LIKE ?",
      '%' + params[:patient][:full_name].downcase.gsub(' ', '%') + '%' ], 
     :joins => "JOIN vcards ON patients.vcard_id = vcards.id",
     :select => "patients.*",
      :order => 'family_name ASC',
      :limit => 8)
    render :partial => 'full_names'
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
       :limit => 12 }

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

  def list
    @case_pages, @cases = paginate :cases, :per_page => 144, :order => params[:order]
  end

  def first_entry_queue
    params[:order] ||= 'praxistar_eingangsnr'
    
    @case_pages, @cases = paginate :cases, :per_page => 144, :order => params[:order], :conditions => 'entry_date IS NULL'
    render :action => :list
  end
  
  def second_entry_queue
    params[:order] ||= 'praxistar_eingangsnr'
    
    @case_pages, @cases = paginate :cases, :per_page => 144, :order => params[:order], :conditions => "entry_date IS NOT NULL AND screened_at IS NULL AND praxistar_eingangsnr > '07/' AND praxistar_eingangsnr < '90/'"
    render :action => :list
  end
  
  def show
    @case = Case.find(params[:id])
  end

  def new
    redirect_to :controller => '/cyto/order_forms', :action => 'new'
  end

  def first_entry
    @case = Case.find(params[:id])
  
    @case.doctor_id = session[:first_entry][:doctor_id] unless session[:first_entry].nil?
    @case.examination_method_id = 1
  end

  def first_entry_update
    session[:first_entry] = {} if session[:first_entry].nil?
    session[:first_entry][:doctor_id] = params[:case][:doctor_id]
    
    params[:case][:patient_id] = params[:patient][:full_name].split(' ')[0].to_i
    params[:case][:entry_date] = Time.now
    
    @case = Case.find(params[:id])
    @case.update_attributes(params[:case])
  
    @case.insurance = @case.patient.insurance
    @case.insurance_nr = @case.patient.insurance_nr
    @case.save
    if Case.exists?(@case.id + 1)
      redirect_to :action => 'first_entry', :id => @case.id + 1
    else
      redirect_to :action => 'first_entry_queue'
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
    
    classification = Classification.find(params[:case][:classification])
    @case.classification = classification
    @case.save
    
    case classification.code
    when '2A', '2-3A'
      render :action => 'second_entry_agus_ascus_form'
    end
  end
  
  def second_entry_update
    @case = Case.find(params[:id])
    
    render :action => 'result_report', :id => @case
  end
  

  def sign
    @case = Case.find(params[:id])
    @case.screened_at = Time.now
    @case.save
  
    redirect_to :action => :list
  end
  
  def remove_finding
    @case = Case.find(params[:id])

    @case.finding_classes.delete(FindingClass.find(params[:finding_id]))
    
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
end
