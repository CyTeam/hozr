class WorkQueueController < ApplicationController

  def overview
  end

  def admin
    @assign_count = Cyto::Case.count(:all, :conditions => 'assigned_at IS NULL' )
    @first_entry_count = Cyto::Case.count(:all, :conditions => 'entry_date IS NULL AND assigned_at IS NOT NULL')
    @print_result_count = Cyto::Case.count(:all, :conditions => '(screened_at IS NOT NULL OR (screened_at IS NULL and needs_p16 = 1 ) ) AND result_report_printed_at IS NULL')
    @bill_export_count = Cyto::Case.count(:all, :conditions => [ "praxistar_leistungsblatt_id IS NULL AND (result_report_printed_at IS NOT NULL AND result_report_printed_at < now() - INTERVAL ? DAY ) AND classification_id IS NOT NULL", 7 ])
    @bill_print_count = Praxistar::LeistungenBlatt.count_by_sql("SELECT count(*) FROM leistungen_blatt JOIN patienten_personalien ON patient_id = id_patient")
    @order_count = Shop::Order.count(:conditions => 'shipped_at IS NULL AND cancelled_at IS NULL')
  end

  def cyto
    @second_entry_count = Cyto::Case.count(:all, :conditions => 'entry_date IS NOT NULL AND screened_at IS NULL AND needs_p16 = 0')
  end
end
