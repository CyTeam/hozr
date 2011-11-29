class AddIndexOnDeliveredAtToCases < ActiveRecord::Migration
  def self.up
    add_index :cases, :delivered_at
  end

  def self.down
    remove_index :cases, :delivered_at
  end
end
