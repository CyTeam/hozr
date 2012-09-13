# encoding: utf-8'
class PatientsController < AuthorizedController
  helper :doctors
  
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

  def directory_lookup
    @patient = Patient.find(params[:id])

    @vcard = @patient.vcard
  end
end
