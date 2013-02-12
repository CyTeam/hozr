# encoding: utf-8'
class WorkQueueController < ApplicationController
  def admin
    @assign_count = OrderForm.unassigned.count
    @first_entry_count = Case.for_first_entry.count
    @second_entry_count = Case.for_second_entry.count
    @p16_count = Case.for_p16.count
    @hpv_count = Case.for_hpv.count
    @p16_prepared_count = Case.count(:all, :conditions => ["needs_p16 = ? AND screened_at IS NULL AND hpv_p16_prepared_at is not NULL", true])
    @review_count = Case.for_review.count
    @result_for_delivery_count = Case.for_delivery.count
    @result_for_billing_count = Case.finished.no_treatment.count
  end
end
