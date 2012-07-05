# encoding: utf-8'
class HonorificPrefixesController < ApplicationController
  def index
    list
    render :action => 'list'
  end

  def list
    @honorific_prefixes = HonorificPrefix.paginate(:page => params['page'], :per_page => 10)
  end

  def show
    @honorific_prefix = HonorificPrefix.find(params[:id])
  end

  def new
    @honorific_prefix = HonorificPrefix.new
  end

  def create
    @honorific_prefix = HonorificPrefix.new(params[:honorific_prefix])
    if @honorific_prefix.save
      flash[:notice] = 'HonorificPrefix was successfully created.'
      redirect_to :action => 'list'
    else
      render :action => 'new'
    end
  end

  def edit
    @honorific_prefix = HonorificPrefix.find(params[:id])
  end

  def update
    @honorific_prefix = HonorificPrefix.find(params[:id])
    if @honorific_prefix.update_attributes(params[:honorific_prefix])
      flash[:notice] = 'HonorificPrefix was successfully updated.'
      redirect_to :action => 'show', :id => @honorific_prefix
    else
      render :action => 'edit'
    end
  end

  def destroy
    HonorificPrefix.find(params[:id]).destroy
    redirect_to :action => 'list'
  end
end
