# encoding: UTF-8

class AddRecordCountToImExports < ActiveRecord::Migration
  def self.up
    add_column :exports, :record_count, :integer
    add_column :imports, :record_count, :integer
  end

  def self.down
    remove_column :exports, :record_count
    remove_column :imports, :record_count
  end
end
