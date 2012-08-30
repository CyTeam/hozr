# encoding: utf-8'
require "net/http"

class Case::PatientsController < ApplicationController
  authorize_resource

  # First Entry
  # ===========
  # Patients
  def index
    query = params[:query]

    @case = Case.find(params[:case_id])
    @patients = Patient.by_text(query, :star => true, :per_page => 30, :page => params[:page])
  end

  def set_new_patient
    @case = Case.find(params[:id])

    patient = params[:patient]
    @patient = Patient.new(patient)
    @vcard = Vcard.new(params[:vcard])
    @patient.billing_vcard = Vcard.new(params[:billing_vcard])
    @vcard.honorific_prefix = 'Frau'

    @patient.doctor = @case.doctor

    render 'patients/edit_inline'
  end

  def edit
    @case = Case.find(params[:case_id])
    @patient = Patient.find(params[:id])
  end

  def new
    @case = Case.find(params[:case_id])

    @patient = Patient.new(params[:patient])
    @patient.build_vcard unless @patient.vcard
    @patient.build_billing_vcard unless @patient.billing_vcard

    @patient.vcard.honorific_prefix = 'Frau'
  end

  def update
    @case = Case.find(params[:case_id])
    @patient = Patient.find(params[:id])

    # Set entry_date only when setting patient for first time
    @case.examination_method_id = @case.intra_day_id == 0 ? 0 : 1

    @case.entry_date ||= Time.now
    @case.first_entry_at ||= Time.now # TODO: kill
    @case.first_entry_by = current_user.object

    # TODO: dynamic lookup of doctor from latest case
    @patient.doctor = @case.doctor
    @case.insurance = @patient.insurance
    @case.insurance_nr = @patient.insurance_nr

    @case.patient = @patient
    if @case.save
      redirect_to next_first_entry_case_path(@case)
    else
      raise "Fehler bei Patient zuweisen"
    end
  end



  def set_patient_back
    @case = Case.find(params[:id])
    # Set entry_date only when setting patient for first time
    @case.entry_date = Time.now if @case.entry_date.nil?
    @case.examination_method_id = @case.intra_day_id == 0 ? 0 : 1

      if params[:patient_id]
        @patient = Patient.find(params[:patient_id])
        @patient.create_billing_vcard if @patient.billing_vcard.nil?
      else
        @patient = Patient.new(params[:patient])
        @patient.build_vcard(params[:vcard])
        @patient.build_billing_vcard(params[:billing_vcard])

        @patient.save
      end

      @vcard = @patient.vcard
      @billing_vcard = @patient.billing_vcard

    # Copy&Paste from patients_controller

    params[:patient][:sex] = HonorificPrefix.find_by_name(params[:vcard][:honorific_prefix]).sex

    if @vcard.update_attributes(params[:vcard]) and @billing_vcard.update_attributes(params[:billing_vcard]) and @patient.update_attributes(params[:patient])
      @vcard.save
      @billing_vcard.save
      @patient.save
      flash[:notice] = 'Patient was successfully updated.'
#      redirect_to :action => 'list'
    else
      flash[:error] = "Couldn't update Patient."
#      render :action => 'edit'
    end
    # END Copy&Paste

      patient = @patient
      patient.doctor = @case.doctor
      patient.doctor_patient_nr = params[:patient][:doctor_patient_nr] unless params[:patient][:doctor_patient_nr].nil?
      patient.save

      @case.patient = patient

      @case.insurance = @case.patient.insurance
      @case.insurance_nr = @case.patient.insurance_nr

    @case.first_entry_at ||= Time.now
    @case.first_entry_by = current_user.object
                  
    if @case.save
      flash[:notice] = 'First entry ok.'

      next_open = Case.where("entry_date IS NULL and id > ?", @case.id).first
      if next_open.nil?
        redirect_to :action => 'first_entry_queue'
      elsif next_open.praxistar_eingangsnr.nil? or next_open.doctor.nil?
        redirect_to :action => 'unassigned_form'
      else
        redirect_to :action => 'first_entry', :id => next_open
      end
    else
      flash[:error] = 'Ersteingabe erzeugte Fehler.'
      @header_image_type = session[:header_image_type] || :head

      render :action => 'first_entry'
    end
  end
end
