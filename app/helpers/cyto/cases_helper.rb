module Cyto::CasesHelper
  def classification_button(code)
    classification = Classification.find_by_code(code)
    
    button_to classification.name, { :action => "second_entry_form", "case[classification]" => classification.id, :id => @case }, :class => "PAP_#{classification.code}"
  end
end
