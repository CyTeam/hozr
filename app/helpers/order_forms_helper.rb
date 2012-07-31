# encoding: utf-8'
module OrderFormsHelper
  def order_form_head_image(order_form, image_type = nil)
    image_type ||= session[:order_form_image_type] || :head

    new_image_type = nil
    case image_type.to_s
    when "head_big"
      new_image_type = :head
    when "head"
      new_image_type = :head_big
    end

    link_to image_tag(inline_order_form_path(order_form, :type => image_type )), head_image_order_form_path(order_form, :type => new_image_type), :remote => true
  end
end
