# encoding: UTF-8

class AddDeliveredAtToCases < ActiveRecord::Migration
  def self.up
    add_column :cases, :delivered_at, :datetime
    
    Case.connection.execute("UPDATE cases SET delivered_at = result_report_printed_at")
    Case.connection.execute("UPDATE cases SET delivered_at = email_sent_at WHERE email_sent_at > result_report_printed_at OR result_report_printed_at IS NULL")
  end

  def self.down
    remove_column :cases, :delivered_at
  end
end
