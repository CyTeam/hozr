class InsurancesController < ApplicationController
  def index
    list
    render :action => 'list'
  end

  # GETs should be safe (see http://www.w3.org/2001/tag/doc/whenToUseGet.html)
  verify :method => :post, :only => [ :destroy, :create, :update ],
         :redirect_to => { :action => :list }

  def list
    @insurance_pages, @insurances = paginate :insurances, :per_page => 10
  end

  def show
    @insurance = Insurance.find(params[:id])
  end

  def new
    @insurance = Insurance.new
  end

  def create
    @insurance = Insurance.new(params[:insurance])
    if @insurance.save
      flash[:notice] = 'Insurance was successfully created.'
      redirect_to :action => 'list'
    else
      render :action => 'new'
    end
  end

  def edit
    @insurance = Insurance.find(params[:id])
  end

  def update
    @insurance = Insurance.find(params[:id])
    if @insurance.update_attributes(params[:insurance])
      flash[:notice] = 'Insurance was successfully updated.'
      redirect_to :action => 'show', :id => @insurance
    else
      render :action => 'edit'
    end
  end

  def destroy
    Insurance.find(params[:id]).destroy
    redirect_to :action => 'list'
  end
end
