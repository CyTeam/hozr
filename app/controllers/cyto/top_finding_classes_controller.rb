include Cyto

class TopFindingClassesController < ApplicationController
  def index
    list
    render :action => 'list'
  end

  # GETs should be safe (see http://www.w3.org/2001/tag/doc/whenToUseGet.html)
  verify :method => :post, :only => [ :destroy, :create, :update ],
         :redirect_to => { :action => :list }

  def list
  end

  def update_classification
    classification = Classification.find(params[:top_finding_class][:classification_id])
    
    for finding_class_code in params[:top_finding_class][:finding_class_codes].split(' ')
      top_finding = TopFindingClass.new
      top_finding.classification = classification
      top_finding.finding_class = FindingClass.find_by_code(finding_class_code)
      top_finding.save
    end
  
    redirect_to :action => :list
  end
  
  def destroy
    TopFindingClass.find(params[:id]).destroy
    redirect_to :action => 'list'
  end
end
