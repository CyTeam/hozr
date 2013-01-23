# encoding: utf-8'
module FindingClassesHelper
  def link_to_add_finding_class(a_case, finding_class)
    case finding_class.code
    when 'a'
      btn_type = 'btn-success'
    when 'b'
      btn_type = 'btn-warning'
    when 'c'
      btn_type = 'btn-danger'
    end

    button_to finding_class.name, add_finding_case_path(a_case, :finding_id => finding_class.id), :method => :post, :remote => true, :class => "btn btn-large #{btn_type} span12"
  end

  def finding_class_collection
    FindingClass.all.map do |finding_class|
      {
        :id => finding_class.code,
        :text => finding_class.code + ' - ' + finding_class.name,
        :strip_text => strip_tags(finding_class.name),
        :name => finding_class.name
      }
    end
  end
end
