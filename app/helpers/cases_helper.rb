module CasesHelper
  def classification_button(code)
    classification = Classification.find_by_code_and_examination_method_id(code, @case.examination_method_id)
    
    button_to classification.name, { :action => "second_entry_form", "case[classification]" => classification.id, :id => @case }, :class => "PAP_#{classification.code}"
  end

 def auto_complete_result_finding_class_selection(entries, field, phrase = nil)
    return unless entries
    items = entries.map { |entry| content_tag("li", phrase ? highlight(entry[field], phrase) : "<span id='#{field}'>#{h(entry[field])} - #{h(strip_tags(entry[:name]))}</span>".html_safe) }
    content_tag("ul", items.uniq.join.html_safe)
  end
  
  def finding_css_class(finding)
    css_class = "finding_class_#{finding.code} "
    css_class += "finding_group_#{finding.finding_group.name}"
  end

  # From CyLab
  def patient_nr
    return nil if @case.patient.doctor_patient_nr.blank?

    return "##{@case.patient.doctor_patient_nr.strip}"
  end

  def patient_birth_date
    return "" if @case.patient.birth_date.nil?

#    CyLab has no implicit cast:
#    return @case.patient.birth_date.strftime("%d.%m.%Y")
    return @case.patient.birth_date
  end

  def insurance_policy
    return "" if @case.insurance.nil?

    return @case.insurance.vcard.full_name + (@case.insurance_nr.present? ? " #{@case.insurance_nr.strip}" : "")
  end

  # SlidePath
  def slidepath_case_url(location_index)
    "https://slidepath.zyto-labor.com/dih/webViewer.php?imageHash=#{location_index.image_hash}"
  end

  def link_to_slidepath_case(a_case)
    links = []
    for location_index in a_case.location_index
      links << link_to("Scan", slidepath_case_url(location_index), :target => 'slidepath')
    end

    links.join(", ").html_safe
  end
end
