include Cyto

class Cyto::DiagnoseController < ApplicationController
  auto_complete_for :finding_class, :selection, :select => "*, code || ' - ' || name as selection", :limit =>12
  auto_complete_for :classification, :name, :limit => 12

  def index
    render :action => 'second_entry_pap_form'
  end

  def deprecated_second_entry_form
    @case = Case.find_by_praxistar_eingangsnr(params[:case][:praxistar_eingangsnr])
    if @case.nil?
      flash[:warning] = "Eingangsnr nicht gefunden: #{params[:case][:praxistar_eingangsnr]}"
      redirect_to :action => 'deprecated_second_entry_pap_form'
    elsif !@case.screened_at.nil?
      flash[:warning] = "Zweiteingabe bereits gemacht: #{params[:case][:praxistar_eingangsnr]}"
      redirect_to :action => 'deprecated_second_entry_pap_form'
    else
      @case.examination_method_id = 1
    end
  end

  def deprecated_create_case
    @case = Case.find(params[:id])
    @case.finding_class_ids = params[:finding_ids]
    @case.screener = Employee.find_by_code('admin')
    @case.screened_at = Time.now
    
    @case.update_attributes(params[:case])
    if @case.save
      flash[:notice] = 'Case was successfully created.'
      redirect_to :action => 'deprecated_second_entry_pap_form'
    else
      render :action => 'deprecated_second_entry_form'
    end
  end
  
  def upload_order_form
  end
  
  def second_entry_queue_list
  end
  
  def add_finding
    begin
      if params[:finding_class][:selection] > ''
        finding_class_code = params[:finding_class][:selection].split(' - ')[0]
      elsif params[:finding_class][:code]
        finding_class_code = params[:finding_class][:code]
      end
      
      finding_class = FindingClass.find_by_code(finding_class_code)
      render_text "<li>#{finding_class.name}<input type='hidden' name='finding_ids[]' value='#{finding_class.id}' readonly='readonly' /></li>"
    rescue
      render_text "<li style='color: red'>Unbekannter Code: #{finding_class_code}</li>"
    end
  end

  def add_top_finding
    top_finding_class_id = params[:top_finding_id]
    finding_class = FindingClass.find(top_finding_class_id)
    render_text "<li>#{finding_class.name}<input type='hidden' name='finding_ids[]' value='#{finding_class.id}' readonly='readonly' /></li>"
  end

  def result_report
    begin
      @findings = FindingClass.find(params[:finding_ids])
    rescue
      @findings = []
    end
    render :layout => false
  end
  
  def p16_result_report
  end
  
  def hpv_result_report
  end
  
  def mama_result_report
  end
  
  def result_queue_list
  end
end
