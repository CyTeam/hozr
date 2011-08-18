class AuthorizedController < InheritedResources::Base
  # Authorization
  load_and_authorize_resource

  # Responders
  respond_to :html, :js

  # Flash helpers
  def created_flash(resource)
    render_to_string(:partial => 'layouts/created_flash', :resource => resource)
  end
end
