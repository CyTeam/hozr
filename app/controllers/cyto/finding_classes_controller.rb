include Cyto

class FindingClassesController < ApplicationController
  def index
    list
    render :action => 'list'
  end

  # GETs should be safe (see http://www.w3.org/2001/tag/doc/whenToUseGet.html)
  verify :method => :post, :only => [ :destroy, :create, :update ],
         :redirect_to => { :action => :list }

  def list
    @finding_classes = FindingClass.paginate(:page => params['page'], :per_page => 100)
  end

  def show
    @finding_class = FindingClass.find(params[:id])
  end

  def new
    @finding_class = FindingClass.new
  end

  def create
    @finding_class = FindingClass.new(params[:finding_class])
    if @finding_class.save
      flash[:notice] = 'FindingClass was successfully created.'
      redirect_to :action => 'list'
    else
      render :action => 'new'
    end
  end

  def edit
    @finding_class = FindingClass.find(params[:id])
  end

  def update
    @finding_class = FindingClass.find(params[:id])
    if @finding_class.update_attributes(params[:finding_class])
      flash[:notice] = 'FindingClass was successfully updated.'
      if FindingClass.exists?(@finding_class.id + 1)
        redirect_to :action => 'edit', :id => @finding_class.id + 1
      else
        redirect_to :action => 'list'
      end
    else
      render :action => 'edit'
    end
  end

  def destroy
    FindingClass.find(params[:id]).destroy
    redirect_to :action => 'list'
  end
end
