class EmployeesController < ApplicationController
  def index
    list
    render :action => 'list'
  end

  # GETs should be safe (see http://www.w3.org/2001/tag/doc/whenToUseGet.html)
  verify :method => :post, :only => [ :destroy, :create, :update ],
         :redirect_to => { :action => :list }

  def list
    @employees = Employee.paginate(:page => params[:page], :per_page => 10)
  end

  def show
    @employee = Employee.find(params[:id])
  end

  def new
    @employee = Employee.new
  end

  def create
    @employee = Employee.new(params[:employee])
    @employee.work_vcard = Vcard.new(params[:work_vcard])
    @employee.private_vcard = Vcard.new(params[:private_vcard])
    
    if @employee.save
      flash[:notice] = 'Employee was successfully created.'
      redirect_to :action => 'list'
    else
      render :action => 'new'
    end
  end

  def edit
    @employee = Employee.find(params[:id])
  end

  def update
    @employee = Employee.find(params[:id])
    if @employee.update_attributes(params[:employee])
      flash[:notice] = 'Employee was successfully updated.'
      redirect_to :action => 'show', :id => @employee
    else
      render :action => 'edit'
    end
  end

  def destroy
    Employee.find(params[:id]).destroy
    redirect_to :action => 'list'
  end
end
