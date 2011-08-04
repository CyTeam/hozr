class ClassificationGroupsController < ApplicationController
  def list
    @classification_groups = ClassificationGroup.order('position').all
  end
  
  def index
    list
    render :action => 'list'
  end
end
