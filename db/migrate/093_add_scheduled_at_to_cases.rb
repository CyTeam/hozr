class AddScheduledAtToCases < ActiveRecord::Migration
  def self.up
    add_column :cases, :scheduled_at, :datetime
    add_column :cases, :scheduled_for, :integer
  end

  def self.down
    remove_column :cases, :scheduled_at
    remove_column :cases, :scheduled_for
  end
end
