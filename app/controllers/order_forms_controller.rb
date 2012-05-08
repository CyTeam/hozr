class OrderFormsController < ApplicationController
  # AJAX functions
  def head_big
    @order_form = OrderForm.find(params[:id])
    session[:header_image_type] = :head_big
    @header_image_type = :head_big
    render 'head_image'
  end

  def head_small
    @order_form = OrderForm.find(params[:id])
    session[:header_image_type] = :head
    @header_image_type = :head
    render 'head_image'
  end
end
