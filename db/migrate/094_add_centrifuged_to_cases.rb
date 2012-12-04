# encoding: UTF-8

class AddCentrifugedToCases < ActiveRecord::Migration
  def self.up
    add_column :cases, :centrifuged_at, :datetime
    add_column :cases, :centrifuged_for, :integer
  end

  def self.down
    remove_column :cases, :centrifuged_at
    remove_column :cases, :centrifuged_for
  end
end
