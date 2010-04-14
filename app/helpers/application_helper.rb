# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  # List helpers
  def sort_header(column, label = nil)
    label ||= column.humanize
    content_tag('th', label + ' ' + link_to(image_tag('up.png'), :order => column) + link_to(image_tag('down.png'), :order => column + ' DESC'))
  end

  def get_user
    request.env['REMOTE_USER']
  end

  # AJAX helpers
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
