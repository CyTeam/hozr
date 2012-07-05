# encoding: utf-8'
class InsurancesController < ApplicationController
  def index
    list
    render :action => 'list'
  end

  def list
    @insurances = Insurance.paginate(:page => params['page'], :per_page => 50)
  end

  def show
    @insurance = Insurance.find(params[:id])
    @vcard = @insurance.vcard
  end

  def new
    @insurance = Insurance.new
  end

  def create
    @insurance = Insurance.new(params[:insurance])
    @insurance.vcard = Vcard.new(params[:vcard])

    if @insurance.save
      flash[:notice] = 'Insurance was successfully created.'
      redirect_to :action => 'list'
    else
      render :action => 'new'
    end
  end

  def edit
    @insurance = Insurance.find(params[:id])
    @vcard = @insurance.vcard
  end

  def update
    @insurance = Insurance.find(params[:id])
    @vcard = @insurance.vcard
    if @vcard.update_attributes(params[:vcard]) and @insurance.update_attributes(params[:insurance])
      flash[:notice] = 'Insurance was successfully updated.'
      redirect_to :action => 'list'
    else
      render :action => 'edit'
    end
  end

  def destroy
    Insurance.find(params[:id]).destroy
    redirect_to :action => 'list'
  end
end
