# encoding: utf-8'

class Date
  # Date helpers
  def self.parse_date(value, base_year = 2000)
    if value.is_a?(String)
      if value.match /.*-.*-.*/
        return value
      end
      day, month, year = value.split('.').map {|s| s.to_i}
      month ||= Date.today.month
      year ||= Date.today.year
      year = expand_year(year, base_year)

      return sprintf("%4d-%02d-%02d", year, month, day)
    else
      return value
    end
  end

  def self.date_only_year?(value)
    value.is_a?(String) and value.strip.match /^\d{2,4}$/
  end

  def self.expand_year(value, base = 2000)
    year = value.to_i
    return year < 100 ? year + base : year
  end
end

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
