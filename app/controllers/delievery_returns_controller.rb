class DelieveryReturnsController < ApplicationController

  def index
    redirect_to :action => :new
  end
  
  def search_by_bill
    bill_params = params[:bill]
    begin
      @cases = [ Praxistar::Bill.find(bill_params[:id]).cyto_case ]
    rescue ActiveRecord::RecordNotFound
      render :inline => '<h2>Nicht gefunden</h2>'
    end
  end
  
  def create
    case_id = params[:id]
    delievery_return = DelieveryReturn.new(:case_id => case_id)
    delievery_return.save!

    redirect_to :action => :new
  end
  
  def new
  end

  def list_new
  end

  def edit
  end

  def doctor_fax
  end

  def list_sent_faxes
  end
end
