class DelieveryReturnsController < ApplicationController

  def index
    redirect_to :action => :new
  end
  
  def search_by_bill
    bill_params = params[:bill]
    begin
      @cases = [ Praxistar::Bill.find(bill_params[:id]).cyto_case ]
      render :partial => '/cyto/cases/list'
    rescue ActiveRecord::RecordNotFound
      render :inline => '<h2>Nicht gefunden</h2>'
    end
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
