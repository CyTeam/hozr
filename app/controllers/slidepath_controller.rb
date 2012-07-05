# encoding: utf-8'
class SlidepathController < ApplicationController
  respond_to :js
  
  def links
    @case = Case.find(params[:case_id])
  end

  def scanned_cases
    @scans = Slidepath::LocationIndex.paginate(:page => params['page'], :per_page => 10)
    # Use uniq to only show one item per case
    # Use compact to get rid of scans with no cases assigned
    @cases = @scans.collect{|scan| scan.a_case}.uniq.compact
  end
end
