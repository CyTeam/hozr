class AdminController < ApplicationController
  def index
  end

  def praxistar_create_all_leistungsblatt
    Cyto::Case.praxistar_create_all_leistungsblatt
    
    render :partial => 'praxistar_create_all_leistungsblatt_status'
  end

  def praxistar_patienten_personalien_export
    Praxistar::PatientenPersonalien.export

    render :partial => 'praxistar_patienten_personalien_export_status'
  end

  def import_order_forms
    Cyto::OrderForm.import_order_forms

    render :partial => 'import_order_forms_status'
  end
end
