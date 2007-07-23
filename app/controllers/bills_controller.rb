class BillsController < ApplicationController
  def index
    redirect_to :action => 'search_form'
  end

  def search
    bill_id = params[:bill][:rechnung_id]

    @bills = Praxistar::Bill.find(bill_id).patient.bills
    render :partial => 'list'
  end
end
