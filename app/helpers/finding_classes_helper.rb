module FindingClassesHelper
  def link_to_add_finding_class(a_case, finding_class)
    link_to finding_class.name, add_finding_case_path(a_case, :finding_id => finding_class.id), :remote => true, :class => "Finding_#{finding_class.code} finding_action"
  end
end
