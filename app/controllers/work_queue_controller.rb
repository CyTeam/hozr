# encoding: utf-8'
class WorkQueueController < ApplicationController
  def admin
    @assign_count = Case.count(:all, :conditions => 'assigned_at IS NULL' )
    @first_entry_count = Case.for_first_entry.count
    @second_entry_count = Case.for_second_entry.count
    @p16_count = Case.count(:all, :conditions => ["needs_p16 = ? AND screened_at IS NULL", true])
    @hpv_count = Case.count(:all, :conditions => ["needs_hpv = ? AND screened_at IS NULL", true])
    @p16_prepared_count = Case.count(:all, :conditions => ["needs_p16 = ? AND screened_at IS NULL AND hpv_p16_prepared_at is not NULL", true])
    @review_count = Case.for_review.count
    @result_for_delivery_count = Case.for_delivery.count
  end

  def cyto
    @second_entry_count = Case.count(:all, :conditions => 'entry_date IS NOT NULL AND screened_at IS NULL AND needs_p16 = 0')
  end
end
