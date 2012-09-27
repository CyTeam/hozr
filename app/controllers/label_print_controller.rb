# encoding: utf-8'
class LabelPrintController < ApplicationController
  authorize_resource :class => false

  # Post address labels
  # ===================
  def post_label_print
    label = Doctor.find(params[:post_label][:doctor_id]).praxis

    # Cleanup table
    Aetiketten.delete_all
    
    # Create new record
    Aetiketten.create(
      :hon_suffix => label.honorific_prefix,
      :fam_name => label.family_name,
      :giv_name => label.given_name,
      :ext_address => label.address.street_address,
      :loc => label.locality,
      :postc => label.postal_code
    )

    # Trigger printing
    trigger('post_triger.txt')
  end 

  # Case labels
  # ===========
  def case_label_print
    @start_praxistar_eingangsnr = params[:start_praxistar_eingangsnr]
    @end_praxistar_eingangsnr = params[:end_praxistar_eingangsnr]
    @cases = Case.for_second_entry.where("praxistar_eingangsnr BETWEEN ? AND ?", @start_praxistar_eingangsnr, @end_praxistar_eingangsnr)

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
    
    redirect_to :action => :case_label
  end

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
  def trigger(filename = 'trigger.txt')
    FileUtils.touch(Rails.root.join('public', 'trigger', filename))
  end
end
