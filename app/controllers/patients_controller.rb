# encoding: utf-8'
class PatientsController < AuthorizedController
  def index
    @patients = Patient.by_text params[:query], :retry_stale => true, :per_page => 50
  end

  def dunning_stopped
    @patients = Patient.dunning_stopped.all
  end
  
  def show_history
    @patient = Patient.find(params[:id])
    @cases = @patient.cases
  end

  def new
    @patient = Patient.new(params[:patient])
    
    @patient.vcard.honorific_prefix = 'Frau'
  end

  def create
    @patient = Patient.new(params[:patient])
    
    # Deduce sex from honorific_prefix
    @patient.sex = HonorificPrefix.find_by_name(@patient.vcard.honorific_prefix).sex

    create!
  end

  def update
    @patient = Patient.find(params[:id])
    
    # Deduce sex from honorific_prefix
    @patient.sex = HonorificPrefix.find_by_name(@patient.vcard.honorific_prefix).sex

    update!
  end

  # Merging
  def propose_merge
    @patient1 = Patient.find(params[:patient1_id])
    @patient2 = Patient.find(params[:patient2_id])
  end

  def merge
    @target_patient = Patient.find(params[:target_patient_id])
    @drop_patient = Patient.find(params[:drop_patient_id])

    @target_patient.merge(@drop_patient)
  end
end
