class WorkQueueController < ApplicationController

  def overview
  end

  def admin
    @assign_count = Cyto::Case.count(:all, :conditions => 'assigned_at IS NULL' )
    @first_entry_count = Cyto::Case.count(:all, :conditions => 'entry_date IS NULL AND assigned_at IS NOT NULL')
    @second_entry_count = Cyto::Case.count(:all, :conditions => "entry_date IS NOT NULL AND screened_at IS NULL AND (needs_p16 = '#{Case.connection.false}' AND needs_hpv = '#{Case.connection.false}') AND praxistar_eingangsnr > '07' AND praxistar_eingangsnr < '90' AND NOT praxistar_eingangsnr LIKE '%-%'")
    @p16_count = Cyto::Case.count(:all, :conditions => ["needs_p16 = ? AND screened_at IS NULL", true])
    @hpv_count = Cyto::Case.count(:all, :conditions => ["needs_hpv = ? AND screened_at IS NULL", true])
    @p16_prepared_count = Cyto::Case.count(:all, :conditions => ["needs_p16 = ? AND screened_at IS NULL AND hpv_p16_prepared_at is not NULL", true])
    @review_count = Cyto::Case.count(:all, :conditions => 'needs_review = 1 AND result_report_printed_at IS NULL')
    @print_result_count = Cyto::Case.count(:all, :include => {:doctor => :user }, :conditions => '(wants_prints IS NULL OR wants_prints = 1) AND (screened_at IS NOT NULL AND needs_review = 0 OR (screened_at IS NULL and needs_p16 = 1) AND needs_review = 0 ) AND ((result_report_printed_at IS NULL AND p16_notice_printed_at IS NULL) OR (result_report_printed_at IS NULL AND p16_notice_printed_at IS NOT NULL AND screened_at IS NOT NULL))')
    @email_result_count = Cyto::Case.count(:all, :include => {:doctor => :user }, :conditions => 'wants_email = 1 AND email_sent_at IS NULL AND screened_at IS NOT NULL AND needs_review = 0')
    @bill_export_count = Cyto::Case.count(:all, :conditions => [ "praxistar_leistungsblatt_id IS NULL AND (result_report_printed_at IS NOT NULL AND result_report_printed_at < now() - INTERVAL ? HOUR ) AND classification_id IS NOT NULL", 156 ])
    begin
      @bill_print_count = Praxistar::LeistungenBlatt.count_by_sql("SELECT count(*) FROM leistungen_blatt JOIN patienten_personalien ON patient_id = id_patient")
    rescue
      @bill_print_count = "Keine Verbindung zu Praxistar"
    end

    begin
      @order_count = Shop::Order.count(:conditions => 'shipped_at IS NULL AND cancelled_at IS NULL')
    rescue
      @order_count = "Keine Verbindung zum Webshop"
    end

    @delievery_return_count = DelieveryReturn.count(:conditions => 'address_verified_at IS NULL AND closed_at IS NULL')
  end

  def admin_munin
    admin
    render :layout => false, :action => 'admin_munin'
  end

  def cyto
    @second_entry_count = Cyto::Case.count(:all, :conditions => 'entry_date IS NOT NULL AND screened_at IS NULL AND needs_p16 = 0')
  end
end
