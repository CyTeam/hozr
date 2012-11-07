# encoding: UTF-8

class AddResultReportPrintedAtToCases < ActiveRecord::Migration
  def self.up
    add_column :cases, :result_report_printed_at, :datetime
  end

  def self.down
    remove_column :cases, :result_report_printed_at
  end
end
