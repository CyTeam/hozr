class AddRemarksToCases < ActiveRecord::Migration
  def self.up
    add_column :cases, :remarks, :text
  end

  def self.down
    remove_column :cases, :remarks
  end
end
