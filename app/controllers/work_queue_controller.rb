class WorkQueueController < ApplicationController

  def overview
  end

  def admin
    @assign_count = Case.count(:all, :conditions => 'assigned_at IS NULL' )
    @first_entry_count = Case.count(:all, :conditions => 'entry_date IS NULL AND assigned_at IS NOT NULL')
    @second_entry_count = Case.count(:all, :conditions => "entry_date IS NOT NULL AND screened_at IS NULL AND (needs_p16 = '#{Case.connection.false}' AND needs_hpv = '#{Case.connection.false}') AND praxistar_eingangsnr > '07' AND praxistar_eingangsnr < '90' AND NOT praxistar_eingangsnr LIKE '%-%'")
    @p16_count = Case.count(:all, :conditions => ["needs_p16 = ? AND screened_at IS NULL", true])
    @hpv_count = Case.count(:all, :conditions => ["needs_hpv = ? AND screened_at IS NULL", true])
    @p16_prepared_count = Case.count(:all, :conditions => ["needs_p16 = ? AND screened_at IS NULL AND hpv_p16_prepared_at is not NULL", true])
    @review_count = Case.count(:all, :conditions => 'needs_review = 1 AND result_report_printed_at IS NULL')
    @print_result_count = Mailing.case_count_without_channel
    @email_result_count = Case.count(:all, :include => {:doctor => :user }, :conditions => 'users.wants_email = 1 AND email_sent_at IS NULL AND screened_at IS NOT NULL AND needs_review = 0')
    @bill_export_count = Case.to_create_leistungsblatt.count
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
  end

  def admin_munin
    admin
    render :layout => false, :action => 'admin_munin'
  end

  def cyto
    @second_entry_count = Case.count(:all, :conditions => 'entry_date IS NOT NULL AND screened_at IS NULL AND needs_p16 = 0')
  end
end
