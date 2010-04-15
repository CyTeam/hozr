include Cyto

class Cyto::ExaminationMethodsController < ApplicationController
  def index
    list
    render :action => 'list'
  end

  # GETs should be safe (see http://www.w3.org/2001/tag/doc/whenToUseGet.html)
  verify :method => :post, :only => [ :destroy, :create, :update ],
         :redirect_to => { :action => :list }

  def list
    @examination_methods = Cyto::ExaminationMethod.paginate(:page => params['page'], :per_page => 10)
  end

  def show
    @examination_method = Cyto::ExaminationMethod.find(params[:id])
  end

  def new
    @examination_method = Cyto::ExaminationMethod.new
  end

  def create
    @examination_method = Cyto::ExaminationMethod.new(params[:examination_method])
    if @examination_method.save
      flash[:notice] = 'ExaminationMethod was successfully created.'
      redirect_to :action => 'list'
    else
      render :action => 'new'
    end
  end

  def edit
    @examination_method = Cyto::ExaminationMethod.find(params[:id])
  end

  def update
    @examination_method = Cyto::ExaminationMethod.find(params[:id])
    if @examination_method.update_attributes(params[:examination_method])
      flash[:notice] = 'ExaminationMethod was successfully updated.'
      redirect_to :action => 'show', :id => @examination_method
    else
      render :action => 'edit'
    end
  end

  def destroy
    Cyto::ExaminationMethod.find(params[:id]).destroy
    redirect_to :action => 'list'
  end
end
