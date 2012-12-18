# encoding: UTF-8

class Case::AssignmentsController < ApplicationController
  # Assigning
  # =========
  def new
    case_code = CaseNr.new
    intra_day_id = 1
    @cases = OrderForm.unassigned.reorder(:created_at).map do |order_form|
      a_case = Case.new(
        :order_form => order_form,
        :intra_day_id => intra_day_id,
        :praxistar_eingangsnr => case_code.to_s
      )
      intra_day_id += 1
      case_code = case_code.inc!

      a_case
    end
  end

  def create
    assigned_at = DateTime.now

    for case_param in params[:case]
      Case.create(case_param.merge(:assigned_at => assigned_at))
    end

    redirect_to admin_work_queue_path
  end
end
