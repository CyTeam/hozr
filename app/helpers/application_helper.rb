# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  def sort_header(column, label = nil)
    label ||= column.humanize
    content_tag('th', label + ' ' + link_to(image_tag('up'), :order => column) + link_to(image_tag('down'), :order => column + ' DESC'))
  end

  def get_user
    request.env['REMOTE_USER']
  end

  def loading_indicator_tag(options)
    image_tag "indicator.gif", :style => "display:none;", :id => loading_indicator_id(options), :alt => "loading indicator", :class => "loading-indicator"
  end

  def loading_indicator_id(options)
    if options[:id].nil?
      "#{options[:scaffold_id]}-#{options[:action]}-loading-indicator"
    else
      "#{options[:scaffold_id]}-#{options[:action]}-#{options[:id]}-loading-indicator"
    end
  end
end
