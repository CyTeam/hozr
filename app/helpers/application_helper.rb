# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  def sort_header(column, label = nil)
    label ||= column.humanize
    content_tag('th', label + ' ' + link_to(image_tag('up'), :order => column) + link_to(image_tag('down'), :order => column + ' DESC'))
  end

  def get_auth_data 
    user, pass = '', '' 
    # extract authorisation credentials 
    if request.env.has_key? 'X-HTTP_AUTHORIZATION' 
      # try to get it where mod_rewrite might have put it 
      authdata = request.env['X-HTTP_AUTHORIZATION'].to_s.split 
    elsif request.env.has_key? 'Authorization' 
      # for Apace/mod_fastcgi with -pass-header Authorization 
      authdata = request.env['Authorization'].to_s.split 
    elsif request.env.has_key? 'HTTP_AUTHORIZATION' 
      # this is the regular location 
      authdata = request.env['HTTP_AUTHORIZATION'].to_s.split  
    elsif request.env.has_key? 'Authorization'
      # this is the regular location, for Apache 2
      authdata = @request.env['Authorization'].to_s.split
    end 

    # at the moment we only support basic authentication 
    if authdata and authdata[0] == 'Basic' 
      user, pass = Base64.decode64(authdata[1]).split(':')[0..1] 
    end 
    return [user, pass]
  end

  def get_user
    user, pass = get_auth_data
    return user
  end
end
