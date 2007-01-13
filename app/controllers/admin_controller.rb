class AdminController < ApplicationController
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
    fork do
      Cyto::OrderForm.import_order_forms
    end
    
    sleep 3
    render :action => 'import_order_forms_status'
  end
end
