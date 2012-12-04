# encoding: UTF-8

class RemoveResultReportPrintedAtAndEmailSentAtFromCases < ActiveRecord::Migration
  def self.up
    remove_column :cases, :result_report_printed_at
    remove_column :cases, :email_sent_at
  end

  def self.down
    add_column :cases, :email_sent_at, :datetime
    add_column :cases, :result_report_printed_at, :datetime
  end
end
