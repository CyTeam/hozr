# encoding: UTF-8

class AddP16NoticePrintedAtToCases < ActiveRecord::Migration
  def self.up
    add_column :cases, :p16_notice_printed_at, :datetime
  end

  def self.down
    remove_column :cases, :p16_notice_printed_at
  end
end
