# encoding: UTF-8

class AddIndexForUpdatedAtInPatients < ActiveRecord::Migration
  def self.up
    add_index :patients, :updated_at
  end

  def self.down
    remove_index :patients, :updated_at
  end
end
