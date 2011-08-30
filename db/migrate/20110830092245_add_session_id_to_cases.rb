class AddSessionIdToCases < ActiveRecord::Migration
  def self.up
    add_column :cases, :session_id, :integer
  end

  def self.down
    remove_column :cases, :session_id
  end
end
