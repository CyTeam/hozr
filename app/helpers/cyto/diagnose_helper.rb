module Cyto::DiagnoseHelper
  def classification_button(code)
    classification = Classification.find_by_code(code)
    
    button_to classification.name, { :action => "second_entry_form", :classification => classification.id }, :style => "background-color: #{classification.color}"
  end
  
  def auto_complete_result_finding_class_selection(entries, field, phrase = nil)
    return unless entries
    items = entries.map { |entry| content_tag("li", phrase ? highlight(entry[field], phrase) : "<span id='#{field}'>#{h(entry[field])} - #{h(entry[:name])}</span>") }
    content_tag("ul", items.uniq)
  end
end
