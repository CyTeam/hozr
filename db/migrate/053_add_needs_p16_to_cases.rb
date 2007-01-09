class AddNeedsP16ToCases < ActiveRecord::Migration
  def self.up
    add_column :cases, :needs_p16, :boolean, :default => false
  end

  def self.down
    remove_column :cases, :needs_p16
  end
end
