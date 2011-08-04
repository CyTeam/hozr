class AdminController < ApplicationController
  def index
  end

  def praxistar_create_all_leistungsblatt
    Case.praxistar_create_all_leistungsblatt
    
    @exports = Praxistar::Exports.where(:model => 'Case').order('finished_at DESC').limit(10).all

    render :partial => 'praxistar_create_all_leistungsblatt_status'
  end

  def praxistar_create_leistungsblatt
    Case.find(params[:id]).praxistar_create_leistungsblatt
    
    redirect_to :controller => 'search', :action => ''
  end

  def praxistar_patienten_personalien_export
    Praxistar::PatientenPersonalien.export

    render :partial => 'praxistar_patienten_personalien_export_status'
  end

  def import_order_forms
    OrderForm.import_order_forms

    render :partial => 'import_order_forms_status'
  end

  def batch_reactivate
    bill_params = params[:bill]
    Praxistar::Bill.batch_reactivate(bill_params[:ids], bill_params[:reason])
  end
  
  def unsign_case
    a_case = Case.find(params[:id])
    a_case.signed_at = nil
    a_case.save
  end
end
