# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
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
    result.gsub!(/<\/br>|<br[ ]*\/>/, "\n")
    result.gsub!(/<\/div>|<\/p>/, '')

    return result
  end

  # Prepare roles to show in select inputs etc.
  def roles_for_collection
    Role.all.map{|role| [role.to_s, role.name.to_s]}
  end

  # CyDoc
  def cydoc_hostname
    if Rails.env.development?
      hostname = "cydoc-dev"
    else
      hostname = "cydoc"
    end
  end

  def cydoc_url_for(path)
    "https://#{cydoc_hostname}/#{path}"
  end

  def link_to_cydoc(title, path, options = {})
    link_to title, cydoc_url_for(path), options.merge(:target => cydoc_hostname)
  end
end
