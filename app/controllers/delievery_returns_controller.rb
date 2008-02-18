class DelieveryReturnsController < ApplicationController

  def index
    redirect_to :action => :new
  end
  
  def search_by_bill
    bill_params = params[:bill]
    begin
      # Pass case as array to standard case list
      @bill = Praxistar::Bill.find(bill_params[:id])
      @cases = [ @bill.cyto_case ]
      render :partial => 'search_by_bill'

    rescue ActiveRecord::RecordNotFound
      render :inline => '<h2>Nicht gefunden</h2>'
    end
  end
  
  def create
    bill = Praxistar::Bill.find(params[:bill_id])
    
    # Set dunning stop and add remark
    patient = bill.patient
    patient.dunning_stop = true
    patient.remarks = "Fanpost #{bill.bill_type}: Manstopp gesetzt am #{Date.today.strftime('%d.%m.%Y')}\n" + patient.remarks
    patient.save!

    # Create new record
    delievery_return = DelieveryReturn.new(:bill => bill)
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
