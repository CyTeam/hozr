class AuthorizedController < InheritedResources::Base
  # Authorization
  load_and_authorize_resource

  rescue_from CanCan::AccessDenied do |exception|
    flash[:alert] = t('cancan.access_denied')
    
    if user_signed_in?
      if request.env["HTTP_REFERER"]
        # Show error on referring page for logged in users
        redirect_to :back
      else
        redirect_to root_path
      end
    else
      # Redirect to login page otherwise
      redirect_to new_user_session_path
    end
  end

  # Responders
  respond_to :html, :js

  # Flash helpers
  def created_flash(resource)
    render_to_string(:partial => 'layouts/created_flash', :resource => resource)
  end
end
