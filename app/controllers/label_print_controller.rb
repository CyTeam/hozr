class LabelPrintController < ApplicationController
  authorize_resource :class => false

  # Post address labels
  # ===================
  def post_label_print
    label = Doctor.find(params[:post_label][:doctor_id]).praxis

    # Cleanup table
    Aetiketten.delete_all
    
    # Create new record
    po_label = Aetiketten.new
    po_label.hon_suffix = label.honorific_prefix
    po_label.fam_name = label.family_name
    po_label.giv_name = label.given_name
    po_label.ext_address = label.address.street_address
    po_label.loc = label.locality
    po_label.postc = label.postal_code
    po_label.save

    # Trigger printing
    system("touch public/trigger/post_triger.txt")
    
    redirect_to :action => :post_label
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
      ot_label = OtLabel.new
      ot_label.sys_id = label.id
      ot_label.prax_nr = label.praxistar_eingangsnr
      ot_label.doc_fname = label.doctor.family_name
      ot_label.doc_gname = label.doctor.given_name
      ot_label.pat_fname = label.patient.vcard.family_name
      ot_label.pat_gname = label.patient.vcard.given_name
      ot_label.pat_bday = label.patient.birth_date
      ot_label.save
    end

    # Trigger printing
    system("touch public/trigger/triger.txt")
    
    redirect_to :action => :case_label
  end

  # P16 Labels
  def case_label_p16
    @cases = Case.all( :conditions => ["(needs_p16 = ? OR needs_hpv = ?) AND screened_at IS NULL", true, true])
     
     # Cleanup table
    OtLabel.delete_all

    # Create new records
    for label in @cases
      ot_label = OtLabel.new
      ot_label.sys_id = label.id
      ot_label.prax_nr = label.praxistar_eingangsnr
      ot_label.doc_fname = label.doctor.family_name
      ot_label.doc_gname = label.doctor.given_name
      ot_label.pat_fname = label.patient.vcard.family_name
      ot_label.pat_gname = label.patient.vcard.given_name
      ot_label.pat_bday = label.patient.birth_date
      ot_label.save
    end

    # Trigger printing
    system("touch public/trigger/triger.txt")
    redirect_to :back
  end

  # Single label print 
  def case_label_single
    @cases = Case.find(params[:id])

    label = @cases
     # Cleanup table
    OtLabel.delete_all

    # Create new records
    ot_label = OtLabel.new
    ot_label.sys_id = label.id
    ot_label.prax_nr = label.praxistar_eingangsnr
    ot_label.doc_fname = label.doctor.family_name
    ot_label.doc_gname = label.doctor.given_name
    ot_label.pat_fname = label.patient.vcard.family_name
    ot_label.pat_gname = label.patient.vcard.given_name
    ot_label.pat_bday = label.patient.birth_date
    ot_label.save

    # Trigger printing
    system("touch public/trigger/triger.txt")
    redirect_to :back
  end

end
