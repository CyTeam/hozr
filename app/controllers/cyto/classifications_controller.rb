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
    @classifications = Cyto::Classification.paginate(:page => params['page'], :per_page => 100, :order => 'examination_method_id DESC, name')
  end

  def show
    @classification = Cyto::Classification.find(params[:id])
  end

  def new
    @classification = Cyto::Classification.new
  end

  def create
    for examination_method in Cyto::ExaminationMethod.find(:all)
      classification = Cyto::Classification.new(params[:classification].merge({:examination_method => examination_method}))
    
      classification.save
    end
    
    redirect_to :action => 'list'
  end

  def edit
    @classification = Cyto::Classification.find(params[:id])
  end

  def update
    @classification = Cyto::Classification.find(params[:id])
    if @classification.update_attributes(params[:classification])
      flash[:notice] = 'Classification was successfully updated.'
      redirect_to :action => 'edit', :id => @classification.id + 1
    else
      render :action => 'edit'
    end
  end

  def destroy
    Cyto::Classification.find(params[:id]).destroy
    redirect_to :action => 'list'
  end
end
