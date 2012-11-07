# encoding: UTF-8

class AddEntryDateToCase < ActiveRecord::Migration
  def self.up
    add_column :cases, :entry_date, :date
  end

  def self.down
  remove_column :cases, :entry_date
  end
end
