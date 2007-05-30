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

  def print_result_reports
    command = "/usr/local/bin/hozr_print_all_result_mailings.sh"
    stream = open("|#{command}")
    output = stream.read
 
    send_data output, :type => 'text/html; charset=utf-8', :disposition => 'inline'
#     render :text => 'Printed'
  end
end
