# encoding: utf-8'

# Filters added to this controller will be run for all controllers in the application.
# Likewise, all the methods added will be available for all controllers.
class ApplicationController < ActionController::Base
  before_filter :authenticate_user!

  protect_from_forgery

  # Sensible access denied handling
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

  # Tenancy
  def current_tenant
    current_user.tenant
  end
end
