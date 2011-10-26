class AdminController < ApplicationController
  authorize_resource :class => false

  def index
  end
  
  def unsign_case
    a_case = Case.find(params[:id])
    a_case.signed_at = nil
    a_case.save
  end
end
