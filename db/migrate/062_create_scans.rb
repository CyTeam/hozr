# encoding: UTF-8

class CreateScans < ActiveRecord::Migration
  def self.up
    create_table :scans do |t|
      t.column :created_at, :datetime
    end
  end

  def self.down
    drop_table :scans
  end
end
