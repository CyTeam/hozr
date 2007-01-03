include Cyto

class Cyto::CasesController < ApplicationController
  auto_complete_for :finding_class, :selection, :select => "*, code || ' - ' || name as selection", :limit =>12
#  auto_complete_for :patient, :family_name, :joins => "JOIN vcards ON patients.vcard_id = vcards.id", :limit => 12
  
  def auto_complete_for_patient_full_name
    @patients = Patient.find(:all, 
      :conditions => [ 'LOWER(given_name || " " || family_name) LIKE ?',
      '%' + params[:patient][:full_name].downcase + '%' ], 
     :joins => "JOIN vcards ON patients.vcard_id = vcards.id",
     :select => "patients.*",
      :order => 'family_name ASC',
      :limit => 8)
    render :partial => 'full_names'
  end
    
  def auto_complete_for_patient_family_name
     find_options = { 
       :conditions => [ "LOWER(family_name) LIKE ?", '%' + params[:patient][:family_name].downcase + '%' ],
       :order => "family_name ASC",
       :select => "patients.*",
       :joins => "JOIN vcards ON patients.vcard_id = vcards.id",
       :limit => 12 }

       @items = Patient.find(:all, find_options)
       render :inline => "<%= auto_complete_result @items, 'family_name' %>"
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

  def show
    @case = Case.find(params[:id])
  end

  def new
    @case = Case.new
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
    case classification.code
    when '2a', '2-3a'
      redirect_to :action => 'second_entry_agus_ascus_form'
    end
  
    @case.classification = classification
    @case.save
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
