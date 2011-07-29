# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  # List helpers
  def sort_header(column, label = nil)
    label ||= column.humanize
    links = label + ' ' + link_to(image_tag('up.png'), :order => column) + link_to(image_tag('down.png'), :order => column + ' DESC')
    content_tag('th', links.html_safe)
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

  # Unescape HTML
  HTML_ESCAPES = [
    ['&uuml;', 'ü'],
    ['&auml;', 'ä'],
    ['&ouml;', 'ö'],
    ['&Uuml;', 'Ü'],
    ['&Auml;', 'Ä'],
    ['&Ouml;', 'Ö'],
  ]

  def html_unescape(value)
    result = value

    for pair in HTML_ESCAPES
      result.gsub!(pair[0], pair[1])
    end

    result.gsub!(/<div>|<p>|<br>/, '')
    result.gsub!(/<\/div>|<\/p>|<\/br>|<br[ ]*\/>/, "\n")

    return result
  end
end
