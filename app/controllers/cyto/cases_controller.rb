class Cyto::CasesController < ApplicationController
  def index
    list
    render :action => 'list'
  end

  # GETs should be safe (see http://www.w3.org/2001/tag/doc/whenToUseGet.html)
  verify :method => :post, :only => [ :destroy, :create, :update ],
         :redirect_to => { :action => :list }

  def list
    @case_pages, @cases = paginate :cases, :per_page => 10
  end

  def show
    @case = Case.find(params[:id])
  end

  def new
    @case = Case.new
  end

  def create
    @case = Case.new(params[:case])
    if @case.save
      flash[:notice] = 'Case was successfully created.'
      redirect_to :action => 'list'
    else
      render :action => 'new'
    end
  end

  def edit
    @case = Case.find(params[:id])
  end

  def update
    @case = Case.find(params[:id])
    if @case.update_attributes(params[:case])
      flash[:notice] = 'Case was successfully updated.'
      redirect_to :action => 'show', :id => @case
    else
      render :action => 'edit'
    end
  end

  def destroy
    Case.find(params[:id]).destroy
    redirect_to :action => 'list'
  end
end
