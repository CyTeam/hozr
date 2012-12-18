# encoding: UTF-8

class Case::AssignmentsController < ApplicationController
  # Assigning
  # =========
  def new
    @cases = OrderForm.unassigned.reorder(:created_at).map do |order_form|
      Case.new(:order_form => order_form)
    end

    @intra_day_id = 1
  end

  def create
    assigned_at = DateTime.now

    for case_param in params[:case]
      Case.create(case_param.merge(:assigned_at => assigned_at))
    end

    redirect_to admin_work_queue_path
  end
end
