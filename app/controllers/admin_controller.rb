class AdminController < ApplicationController
  ORDER_FORM_DIR='/mnt/worker/hozr-order-forms/order-*'
  
  def index
  end

  def praxistar_create_all_leistungsblatt
    praxistar_patienten_personalien_export
    @export = Cyto::Case.praxistar_create_all_leistungsblatt
  end

  def praxistar_patienten_personalien_export
    @export = Praxistar::PatientenPersonalien.export
  end

  def import_order_forms
    order_form_files = Dir.glob(ORDER_FORM_DIR)
  
    for order_form_file in order_form_files
      Cyto::OrderForm.new(:file => File.new(order_form_file))
    end
  
    render :action => 'index'
  end
end
