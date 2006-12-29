# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  def sort_header(column)
    return link_to(image_tag('up'), :order => column) + link_to(image_tag('down'), :order => column + ' DESC')
  end

end
