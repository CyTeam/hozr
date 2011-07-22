class LabelPrintController < ApplicationController
  helper :label_print
  
  def label
      @start_praxnr = params[:start_praxnr]
      @end_praxnr = params[:end_praxnr]
      @cases = Case.find(:all, :conditions => ["entry_date IS NOT NULL AND screened_at IS NULL AND (needs_p16 = '#{Case.connection.false}' AND needs_hpv = '#{Case.connection.false}') AND praxistar_eingangsnr BETWEEN ? AND ? AND praxistar_eingangsnr > '01' AND praxistar_eingangsnr < '90' AND NOT praxistar_eingangsnr LIKE '%-%'",@start_praxnr,@end_praxnr ])
      label_save
      set_triger
  end

  def post_label
	post_label_print
  end
   
  def post_label_print
	label = Vcard.find(Doctor.find(params[:order_form][:doctor_id]).praxis_vcard)
	po_label = Aetiketten.new
	po_label.hon_suffix=label.honorific_prefix
	po_label.fam_name=label.family_name
	po_label.giv_name=label.given_name
	po_label.ext_address=label.praxis.address.street_address
	po_label.loc=label.praxis.locality
	po_label.postc=label.praxis.postal_code
	po_label.save
  end 

  def post_label_delete
	Aetiketten.delete_all
  end

  def label_save
    label_delete
    for label in @cases
      ot_label = OtLabel.new
      ot_label.sys_id=label.id
      ot_label.prax_nr=label.praxistar_eingangsnr
      ot_label.doc_fname=label.doctor.family_name
      ot_label.doc_gname=label.doctor.given_name
      ot_label.pat_fname=label.patient.vcard.family_name
      ot_label.pat_gname=label.patient.vcard.given_name
      ot_label.pat_bday=label.patient.birth_date
      ot_label.save
    end
  end
  
  def label_delete
    OtLabel.delete_all
  end
  
  def set_triger
    system("touch public/triger/triger.txt")
  end
end
