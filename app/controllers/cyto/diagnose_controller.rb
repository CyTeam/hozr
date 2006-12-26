include Cyto

class Cyto::DiagnoseController < ApplicationController
  auto_complete_for :finding_class, :selection, :select => "*, code || ' - ' || description as selection", :limit =>12
  auto_complete_for :classification, :description, :limit => 12

  def index
    second_entry_pap_form
    render :action => 'second_entry_pap_form'
  end

  def second_entry_pap_form
  end

  def upload_order_form
  end
  
  def first_entry_form
  end
  
  def second_entry_form
  end
  
  def second_entry_queue_list
  end
  
  def add_finding
    finding_class_selection = params[:finding_class][:selection]
    finding_class_code = finding_class_selection.split(' - ')[0]
    finding_class = FindingClass.find_by_code(finding_class_code)
    render_text "<li>#{finding_class.description}<input type='hidden' name='finding_ids[]' value='#{finding_class.id}' readonly='readonly' /></li>"
  end

  def add_top_finding
    top_finding_class_id = params[:top_finding_id]
    finding_class = FindingClass.find(top_finding_class_id)
    render_text "<li>#{finding_class.description}<input type='hidden' name='finding_ids[]' value='#{finding_class.id}' readonly='readonly' /></li>"
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
