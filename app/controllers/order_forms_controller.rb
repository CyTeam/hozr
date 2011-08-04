class OrderFormsController < ApplicationController
  # AJAX functions
  def head_big
    @order_form = OrderForm.find(params[:id])
    session[:header_image_type] = :head_big
    render :inline => '<%= (link_to image_tag(url_for_image_column(@order_form, "file", :head_big)), url_for_file_column(@order_form, "file")) unless @order_form.nil? %>'
  end

  def head_small
    @order_form = OrderForm.find(params[:id])
    session[:header_image_type] = :head
    render :inline => '<%= (link_to image_tag(url_for_image_column(@order_form, "file", :head)), url_for_file_column(@order_form, "file")) unless @order_form.nil? %>'
  end
end
