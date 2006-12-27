module Cyto::DiagnoseHelper
  def classification_button(code)
    classification = Classification.find_by_code(code)
    
    button_to classification.name, { :action => "second_entry_form", :classification => classification.id }, :style => "background-color: #{classification.color}"
  end
end
