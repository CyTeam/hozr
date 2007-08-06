class WorkQueueController < ApplicationController

  def overview
  end

  def admin
    @assign_count = Cyto::Case.count(:all, :conditions => 'assigned_at IS NULL' )
    @first_entry_count = Cyto::Case.count(:all, :conditions => 'entry_date IS NULL')
    @print_result_count = Cyto::Case.count(:all, :conditions => '(screened_at IS NOT NULL OR (screened_at IS NULL and needs_p16 = 1 ) ) AND result_report_printed_at IS NULL')
    @bill_export_count = Cyto::Case.count(:all, :conditions => [ "praxistar_leistungsblatt_id IS NULL AND (result_report_printed_at IS NOT NULL AND result_report_printed_at < now() - INTERVAL ? DAY ) AND classification_id IS NOT NULL", 7 ])
  end

  def cyto
    @second_entry_count = Cyto::Case.count(:all, :conditions => 'entry_date IS NOT NULL AND screened_at IS NULL AND needs_p16 = 0')
  end
end
