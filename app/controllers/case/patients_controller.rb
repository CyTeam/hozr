# encoding: UTF-8

class Case::PatientsController < ApplicationController
  authorize_resource

  # First Entry
  # ===========
  # Patients
  def index
    query = params[:query]

    @case = Case.find(params[:case_id])
    @patients = Patient.by_text(query, :star => true, :retry_stale => true, :per_page => 100, :page => params[:page])
  end

  def edit
    @case = Case.find(params[:case_id])
    @patient = Patient.find(params[:id])
  end

  def new
    @case = Case.find(params[:case_id])

    @patient = Patient.new(params[:patient])

    @patient.vcard.honorific_prefix = 'Frau'

    # TODO: dynamic lookup of doctor from latest case
    @patient.doctor = @case.doctor
  end

  def update
    @case = Case.find(params[:case_id])
    @patient = Patient.find(params[:id])

    @case.patient = @patient

    @patient.assign_attributes(params[:patient])

    @case.examination_method_id = @case.intra_day_id == 0 ? 0 : 1

    # Set entry_date only when setting patient for first time
    @case.first_entry_at ||= Time.now
    @case.first_entry_submitter ||= current_user.object

    # TODO: dynamic lookup of doctor from latest case
    @patient.doctor ||= @case.doctor
    @case.insurance = @patient.insurance
    @case.insurance_nr = @patient.insurance_nr

    if @case.save
      # CyDoc Support
      # TODO: check and fix
      # if session = @case.session
        # Break relation if there's a CyDoc case
        # @case.update_attribute(:session_id, nil)
        # flash.alert = render_to_string(:partial => 'flash_cydoc_session', :locals => {:session => session}).html_safe
      # end

      if next_case = @case.next_case(:for_first_entry)
        @redirect_path = first_entry_case_path(next_case)
      else
        @redirect_path = first_entry_queue_cases_path
      end

      if request.xhr?
        render 'redirect'
      else
        redirect_to @redirect_path
      end
    else
      render 'edit'
    end
  end

  def create
    @case = Case.find(params[:case_id])
    @patient = @case.build_patient(params[:patient])

    # Deduce sex from honorific_prefix
    @patient.sex = HonorificPrefix.find_by_name(@patient.vcard.honorific_prefix).sex

    # Set entry_date only when setting patient for first time
    @case.examination_method_id = @case.intra_day_id == 0 ? 0 : 1

    @case.first_entry_at ||= Time.now
    @case.first_entry_submitter = current_user.object

    # TODO: dynamic lookup of doctor from latest case
    @patient.doctor ||= @case.doctor
    @case.insurance = @patient.insurance
    @case.insurance_nr = @patient.insurance_nr

    if @case.save
      if next_case = @case.next_case(:for_first_entry)
        @redirect_path = first_entry_case_path(next_case)
      else
        @redirect_path = first_entry_queue_cases_path
      end

      if request.xhr?
        render 'redirect'
      else
        redirect_to @redirect_path
      end
    else
      render 'edit'
    end
  end

  def destroy
    @patient = Patient.find(params[:id])
    @patient.destroy
  end
end
