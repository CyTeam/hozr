class AdminController < ApplicationController
  def index
  end

  def praxistar_create_all_leistungsblatt
    system "../../script/runner Cyto::Case.praxistar_create_all_leistungsblatt"
    
    sleep 3
    render :action => 'praxistar_create_all_leistungsblatt_status'
  end

  def praxistar_patienten_personalien_export
    system "../../script/runner Praxistar::PatientenPersonalien.export"
    
    sleep 3
    render :action => 'praxistar_patienten_personalien_export_status'
  end

  def import_order_forms
    system "../../script/runner Cyto::OrderForm.import_order_forms"
    
    sleep 3
    render :action => 'import_order_forms_status'
  end
end
