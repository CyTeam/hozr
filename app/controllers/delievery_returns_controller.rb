class DelieveryReturnsController < ApplicationController
  helper :doctors
  
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

  def overview
    @new = DelieveryReturn.find(:all, :include => :cyto_case, :order => 'doctor_id', :conditions => ['closed_at IS NULL'])
    @address_verified = DelieveryReturn.find(:all, :include => :cyto_case, :group_by => 'doctor_id', :conditions => ['closed_at IS NULL AND address_verified_at IS NULL'])
    @fax_sent = DelieveryReturn.find(:all, :include => :cyto_case, :group_by => 'doctor_id', :conditions => ['closed_at IS NULL AND fax_sent_at IS NOT NULL'])
  end
  
  def list_new
    @delievery_returns = DelieveryReturn.find(:all, :include => :cyto_case, :order => 'doctor_id', :conditions => ['closed_at IS NULL'])
  end

  def edit
    @delievery_return = DelieveryReturn.find(params[:id])
    @case = @delievery_return.cyto_case
  end

  def update
    @delievery_return = DelieveryReturn.find(params[:id])
  end
  
  def doctor_fax
  end

  def list_sent_faxes
  end
end
