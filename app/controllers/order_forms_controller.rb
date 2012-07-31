# encoding: utf-8'
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
