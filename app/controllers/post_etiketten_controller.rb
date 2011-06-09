class PostEtikettenController < ApplicationController

  def post
  end

  def create
	@prax = params[:doctor_id]
        @label = Vcard.find(Doctor.find(@prax).praxis_vcard) rescue nil

        Aetiketten.delete_all

        po_label = Aetiketten.new
        po_label.hon_suffix=@label.honorific_prefix
        po_label.fam_name=@label.family_name
        po_label.giv_name=@label.given_name
        po_label.ext_address=@label.address.street_address
        po_label.loc=@label.locality
        po_label.postc=@label.postal_code
        po_label.save
        system("touch public/triger/post_triger.txt")

        render :action => 'post'
  end

end
