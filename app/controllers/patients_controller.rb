# encoding: utf-8'
class PatientsController < AuthorizedController
  def index
    @patients = Patient.by_text params[:query], :star => true, :retry_stale => true, :per_page => 50, :page => (params[:page] || 1)

    respond_to do |format|
      format.html
      format.json do
        patients = @patients.collect do |patient|
          {
            :id => patient.id,
            :text => patient.to_s
          }
        end.to_json

        render :json => patients
      end
    end
  end

  def dunning_stopped
    @patients = Patient.dunning_stopped.all
  end

  def show_history
    @patient = Patient.find(params[:id])
    @cases = @patient.cases
  end

  def new
    # Use default sex from doctor settings
    case current_tenant.settings['patients.sex']
      when 'M'
        resource.sex = 'M'
        resource.vcard.honorific_prefix = 'Herr'
      when 'F'
        resource.sex = 'F'
        resource.vcard.honorific_prefix = 'Frau'
    end

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

    Patient.transaction do
      @target_patient.merge(@drop_patient)
      @target_patient.save!(:validate => false)

      logger.warn(@drop_patient.to_s)
      logger.warn(@drop_patient.inspect)
      logger.warn(@drop_patient.vcard.inspect)
      logger.warn(@drop_patient.vcard.address.inspect)

      @drop_patient.destroy
    end
  end
end
