class DoctorsController < ApplicationController
  def index
    list
    render :action => 'list'
  end

  # GETs should be safe (see http://www.w3.org/2001/tag/doc/whenToUseGet.html)
  verify :method => :post, :only => [ :destroy, :create, :update ],
         :redirect_to => { :action => :list }

  def list
    @doctor_pages, @doctors = paginate :doctors, :per_page => 10
  end

  def show
    @doctor = Doctor.find(params[:id])
  end

  def new
    @doctor = Doctor.new
  end

  def create
    @doctor = Doctor.new(params[:doctor])
    if @doctor.save
      flash[:notice] = 'Doctor was successfully created.'
      redirect_to :action => 'list'
    else
      render :action => 'new'
    end
  end

  def edit
    @doctor = Doctor.find(params[:id])
  end

  def update
    @doctor = Doctor.find(params[:id])
    if @doctor.update_attributes(params[:doctor])
      flash[:notice] = 'Doctor was successfully updated.'
      redirect_to :action => 'show', :id => @doctor
    else
      render :action => 'edit'
    end
  end

  def destroy
    Doctor.find(params[:id]).destroy
    redirect_to :action => 'list'
  end
end
