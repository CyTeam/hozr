# encoding: utf-8'
class LabelPrintController < ApplicationController
  authorize_resource :class => false

  # P16 Labels
  def case_label_p16
    @cases = Case.for_hpv_p16
     
     # Cleanup table
    OtLabel.delete_all

    # Create new records
    for label in @cases
      OtLabel.create(
        :sys_id => label.id,
        :prax_nr => label.praxistar_eingangsnr,
        :doc_fname => label.doctor.family_name,
        :doc_gname => label.doctor.given_name,
        :pat_fname => label.patient.vcard.family_name,
        :pat_gname => label.patient.vcard.given_name,
        :pat_bday => label.patient.birth_date
      )
    end

    # Trigger printing
    trigger

    redirect_to :back
  end

  # Single label print 
  def case_label_single
    @cases = Case.find(params[:id])

    label = @cases
     # Cleanup table
    OtLabel.delete_all

    # Create new records
    OtLabel.create(
      :sys_id => label.id,
      :prax_nr => label.praxistar_eingangsnr,
      :doc_fname => label.doctor.family_name,
      :doc_gname => label.doctor.given_name,
      :pat_fname => label.patient.vcard.family_name,
      :pat_gname => label.patient.vcard.given_name,
      :pat_bday => label.patient.birth_date
    )

    # Trigger printing
    trigger

    redirect_to :back
  end

  private
  def trigger(filename = 'triger.txt')
    FileUtils.touch(Rails.root.join('public', 'trigger', filename))
  end
end
