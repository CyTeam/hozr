class Cyto::TopFindingClassesController < ApplicationController
  def index
    list
    render :action => 'list'
  end

  # GETs should be safe (see http://www.w3.org/2001/tag/doc/whenToUseGet.html)
  verify :method => :post, :only => [ :destroy, :create, :update ],
         :redirect_to => { :action => :list }

  def list
    @top_finding_class_pages, @top_finding_classes = paginate :top_finding_classes, :per_page => 10
  end

  def show
    @top_finding_class = TopFindingClass.find(params[:id])
  end

  def new
    @top_finding_class = TopFindingClass.new
  end

  def create
    @top_finding_class = TopFindingClass.new(params[:top_finding_class])
    if @top_finding_class.save
      flash[:notice] = 'TopFindingClass was successfully created.'
      redirect_to :action => 'list'
    else
      render :action => 'new'
    end
  end

  def edit
    @top_finding_class = TopFindingClass.find(params[:id])
  end

  def update
    @top_finding_class = TopFindingClass.find(params[:id])
    if @top_finding_class.update_attributes(params[:top_finding_class])
      flash[:notice] = 'TopFindingClass was successfully updated.'
      redirect_to :action => 'show', :id => @top_finding_class
    else
      render :action => 'edit'
    end
  end

  def destroy
    TopFindingClass.find(params[:id]).destroy
    redirect_to :action => 'list'
  end
end
