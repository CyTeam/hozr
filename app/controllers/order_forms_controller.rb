# encoding: utf-8'
class OrderFormsController < ApplicationController
  # AJAX functions
  def head_image
    @order_form = OrderForm.find(params[:id])
    @image_type = params[:type] || session[:order_form_image_type]

    session[:order_form_image_type] = @image_type

    render 'head_image'
  end

  def show
    @order_form = OrderForm.find(params[:id])
  end

  # Image
  def download
    order_form = OrderForm.find(params[:id])
    type = params[:type]

    path = order_form.file(type)
    send_file path
  end

  def inline
    order_form = OrderForm.find(params[:id])
    type = params[:type]

    path = order_form.file(type)
    send_file path, :disposition => 'inline'
  end
end
