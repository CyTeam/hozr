module OrderFormsHelper
  def order_form_head_image(order_form, header_image_type)
    return unless order_form
    
    link_to image_tag(inline_order_form_url(order_form, :type => header_image_type )), inline_order_form_url(order_form)
  end
end
