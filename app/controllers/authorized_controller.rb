# encoding: utf-8'
class AuthorizedController < InheritedResources::Base
  # Set scope for pagination
  has_scope :page, :default => 1

  # Authorization
  load_and_authorize_resource

  # Responders
  respond_to :html, :js

  # Flash helpers
  def created_flash(resource)
    render_to_string(:partial => 'layouts/created_flash', :resource => resource)
  end
end
