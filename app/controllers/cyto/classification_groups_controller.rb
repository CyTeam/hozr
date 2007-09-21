class Cyto::ClassificationGroupsController < ApplicationController
  scaffold :classification_group

  def list
    @classification_groups = ClassificationGroup.find(:all, :order => 'position')
  end
  
  def index
    list
    render :action => 'list'
  end
end
