class Cyto::CasesController < ApplicationController
  auto_complete_for :finding_class, :selection, :select => "*, code || ' - ' || name as selection", :limit =>12
  
  def index
    list
    render :action => 'list'
  end

  # GETs should be safe (see http://www.w3.org/2001/tag/doc/whenToUseGet.html)
  verify :method => :post, :only => [ :destroy, :create, :update ],
         :redirect_to => { :action => :list }

  def list
    @case_pages, @cases = paginate :cases, :per_page => 144, :order => 'praxistar_eingangsnr DESC'
  end

  def show
    @case = Case.find(params[:id])
  end

  def new
    @case = Case.new
  end

  def create
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
    
    case Classification.find(params[:classification]).code
    when '2a', '2-3a'
      render :action => 'second_entry_agus_ascus_form'
    end
  end
  
  def remove_finding
    @case = Case.find(params[:id])

    @case.finding_classes.delete(FindingClass.find(params[:finding_id]))
    
    render :partial => 'list_findings'
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
    
    render :partial => 'list_findings'
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
