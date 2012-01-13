class SlidepathController < ApplicationController
  respond_to :js
  
  def links
    @case = Case.find(params[:case_id])
  end
end
