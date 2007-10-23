include Cyto

class Cyto::ClassificationsController < ApplicationController
  def index
    list
    render :action => 'list'
  end

  # GETs should be safe (see http://www.w3.org/2001/tag/doc/whenToUseGet.html)
  verify :method => :post, :only => [ :destroy, :create, :update ],
         :redirect_to => { :action => :list }

  def list
    @classification_pages, @classifications = paginate 'Cyto::Classifications', :per_page => 100, :order => 'examination_method_id DESC, name'
  end

  def show
    @classification = Classification.find(params[:id])
  end

  def new
    @classification = Classification.new
  end

  def create
    for examination_method in ExaminationMethod.find(:all)
      classification = Classification.new(params[:classification].merge({:examination_method => examination_method}))
    
      classification.save
    end
    
    redirect_to :action => 'list'
  end

  def edit
    @classification = Classification.find(params[:id])
  end

  def update
    @classification = Classification.find(params[:id])
    if @classification.update_attributes(params[:classification])
      flash[:notice] = 'Classification was successfully updated.'
      redirect_to :action => 'edit', :id => @classification.id + 1
    else
      render :action => 'edit'
    end
  end

  def destroy
    Classification.find(params[:id]).destroy
    redirect_to :action => 'list'
  end
end
