module OrderFormsHelper
  def order_form_head_image(order_form, header_image_type)
    return unless order_form
    
    link_to image_tag(url_for_image_column(order_form, "file", header_image_type )), url_for_file_column(order_form, "file")
  end
end
