# encoding: utf-8'
module CasesHelper
  def cases_for_assignment_collection
    Case.for_scanning.collect {|a_case| [a_case.code, a_case.id]}
  end

  def classification_button(code)
    classification = Classification.find_by_code_and_examination_method_id(code, @case.examination_method_id)

    boot_type = map_classification_to_boot_type(classification)
    button_to classification.name, classification_update_case_path(@case, "case[classification]" => classification.id), :class => "btn btn-large btn-#{boot_type} span12"
  end

  def map_classification_to_boot_type(classification)
    color = classification.try(:classification_group).try(:color)

    return '' unless color

    label = case color
    when 'ff0000', 'red'
      'danger'
    when 'ffff00', 'yellow'
      'yellow'
    when '0066ff', 'blue'
      'primary'
    when 'ff0000', 'red'
      'important'
    when '00cc00', 'green'
      'success'
    when 'lightgray'
      'default'
    else
      'white'
    end
  end

  def finding_css_class(finding)
    css_class = "finding_class_#{finding.code} "
    css_class += "finding_group_#{finding.finding_group.name}"
  end

  def hpv_p16_prepared_text(a_case)
    "#{a_case.hpv_p16_prepared_at.strftime('%d.%m.%Y')} #{a_case.hpv_p16_prepared_by.nil? ? "" : a_case.hpv_p16_prepared_by.code}"
  end

  def findings_text(a_case)
    a_case.finding_classes.collect{|finding| finding.name}.join("<br/>").html_safe
  end

  # Labels
  def case_label_classes(a_case)
    boot_type = map_classification_to_boot_type(a_case.classification)

    return "label label-#{boot_type}"
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
    "http://slidepath.zyto-labor.com/dih/webViewer.php?imageHash=#{location_index.image_hash}"
  end

  def link_to_slidepath_scan(location_index)
    link_to(t_attr(:scan, Case), slidepath_case_url(location_index), :target => 'slidepath')
  end

  def link_to_slidepath_case(a_case)
    links = []
    for location_index in a_case.location_index
      links << link_to_slidepath_scan(location_index)
    end

    links.join(", ").html_safe
  end
end
