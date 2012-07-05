# encoding: utf-8'
class DoctorsController < AuthorizedController

  def index
    params[:order] ||= 'vcards.family_name, vcards.given_name'
    
    @doctors = Doctor.includes(:praxis).order(params[:order]).active.all
  end

  def show
    @doctor = Doctor.find(params[:id])
  end

  def new
    @doctor = Doctor.new
  end

  def create
    @doctor = Doctor.new(params[:doctor])
    @doctor.praxis = Vcard.new(params[:praxis_vcard])
    @doctor.private = Vcard.new(params[:private_vcard])
    
    if @doctor.save
      flash[:notice] = 'Doctor was successfully created.'
      redirect_to doctors_path
    else
      render :action => 'new'
    end
  end

  def edit
    @doctor = Doctor.find(params[:id])
    @praxis_vcard = @doctor.praxis
    @private_vcard = @doctor.private
  end

  def update
    @doctor = Doctor.find(params[:id])
    if @doctor.praxis.update_attributes(params[:praxis_vcard]) and @doctor.private.update_attributes(params[:private_vcard]) and @doctor.update_attributes(params[:doctor])
      @doctor.touch
      
      flash[:notice] = 'Doctor was successfully updated.'
      redirect_to :action => 'show', :id => @doctor
    else
      render :action => 'edit'
    end
  end

  def destroy
    Doctor.find(params[:id]).destroy
    redirect_to doctors_path
  end

  # Customers Support
  # =================
  # LDIF
  def ldif
    @doctor = Doctor.find(params[:id])
    render :layout => false
  end
end
