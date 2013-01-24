# encoding: UTF-8

class Case::AssignmentsController < ApplicationController
  # Assigning
  # =========
  def new
    @order_forms = OrderForm.unassigned.reorder(:created_at).map do |order_form|
      if order_form.code
        a_case = Case.where(:praxistar_eingangsnr => order_form.code).first
        order_form.case = a_case if a_case
      end
      order_form
    end
  end

  def create
    assigned_at = DateTime.now

    if params[:order_forms]
      params[:order_forms].each do |id, values|
        order_form = OrderForm.find(id)
        order_form.case_id = values["case_id"]
        if order_form.case
          order_form.case.examination_date = values["examination_date"]
          order_form.case.doctor_id = values["doctor_id"]
          order_form.case.assigned_at = assigned_at
          order_form.save!
        end
      end
    end

    redirect_to new_case_assignments_path
  end
end
