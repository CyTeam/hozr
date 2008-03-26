class DelieveryReturnsController < ApplicationController
  helper :doctors
  
  def index
    redirect_to :action => :overview
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
    @new_count = DelieveryReturn.count(:all, :conditions => ['address_verified_at IS NULL AND closed_at IS NULL'])
    @doctor_count = DelieveryReturn.count(:all, :conditions => ['fax_sent_at IS NULL AND address_verified_at IS NOT NULL'])
  end
  
  def list_new
    @delievery_returns = DelieveryReturn.find(:all, :include => :cyto_case, :order => 'doctor_id', :conditions => ['closed_at IS NULL'])
    render :action => 'doctor_fax'
  end

  def new_queue
    next_open = DelieveryReturn.find(:first, :conditions => ['address_verified_at IS NULL AND closed_at IS NULL'])
    if next_open.nil?
      redirect_to :action => :overview
    else
      redirect_to :action => :edit, :id => next_open
    end
  end

  def edit
    @delievery_return = DelieveryReturn.find(params[:id])
    @case = @delievery_return.cyto_case

    # Header image size preferences
    @header_image_type = session[:header_image_type] || :head
  end

  def update
    @delievery_return = DelieveryReturn.find(params[:id])
    cyto_case = @delievery_return.cyto_case
    patient = cyto_case.patient
    bill = cyto_case.active_bill
    
    case params[:commit]
    when "Adresse angepasst"
      @vcard = patient.vcard
      @billing_vcard = patient.billing_vcard
      @vcard.update_attributes(params[:vcard]) and @billing_vcard.update_attributes(params[:billing_vcard]) and patient.update_attributes(params[:patient])
      @vcard.save!
      @billing_vcard.save!
      patient.save!

      patient.dunning_stop = false
      patient.remarks = "Fanpost #{bill.bill_type}: Adresse angepasst am #{Date.today.strftime('%d.%m.%Y')}\n" + patient.remarks
      patient.save!

      # TODO: not nice
      bill.reactivate("Adresse angepasst am #{Date.today.strftime('%d.%m.%Y')}") unless bill.nil?
  
      @delievery_return.address_verified_at = DateTime.now
      @delievery_return.closed_at = DateTime.now
      @delievery_return.save!

    when "Fax an Arzt"
      @delievery_return.address_verified_at = DateTime.now
      @delievery_return.save!
    end

    redirect_to :action => :new_queue
  end
  
  def doctor_fax
    @delievery_returns = DelieveryReturn.find(:all, :include => :cyto_case, :order => 'doctor_id', :conditions => ['address_verified_at IS NOT NULL AND closed_at IS NULL'])
  end

  def list_sent_faxes
  end
end
