class BillsController < ApplicationController
  def index
    redirect_to :action => 'search_form'
  end

  def search
    bill_id = params[:bill][:id]

    @bills = Praxistar::Bill.find(bill_id).patient.bills
    render :partial => 'list'
  end

  def list
    @bills = Praxistar::Bill.find(params[:id]).patient.bills
  end

  def cancel
    bill = Praxistar::Bill.find(params[:id])
    bill.cancel
    list
    render :action => :list
  end

  def reactivate
    bill = Praxistar::Bill.find(params[:id])
    bill.reactivate
    list
    render :action => :list
  end
end
