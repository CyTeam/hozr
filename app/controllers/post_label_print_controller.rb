# encoding: utf-8'
class PostLabelPrintController < LabelPrintController
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
end
