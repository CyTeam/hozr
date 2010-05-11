class BillsController < ApplicationController
  def index
    redirect_to :action => 'search_form'
  end

  def search
    bill_id = params[:bill][:id]

    @patient = Praxistar::Bill.find(bill_id).patient
    @bills = @patient.bills
    render :partial => 'list'
  end

  def search_by_patient
    patient_id = params[:id]

    @patient = Patient.find(patient_id)
    @bills = @patient.bills
    render :action => 'list'
  end

  def list
    @bill = Praxistar::Bill.find(params[:id])
    @patient = @bill.patient
    @bills = @patient.bills
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

  # Treatment editing
  def show_treatment_reason
    @bill = Praxistar::Bill.find(params[:bill][:id])
  end

  def update_treatment_reason
    @bill = Praxistar::Bill.find(params[:id])
    @bill.treatment_reason = params[:bill][:treatment_reason]
    @bill.save!
    
    redirect_to :controller => 'admin'
  end
end
