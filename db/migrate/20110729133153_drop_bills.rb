# encoding: UTF-8

class DropBills < ActiveRecord::Migration
  def self.up
    drop_table :bills
  end

  def self.down
  end
end
