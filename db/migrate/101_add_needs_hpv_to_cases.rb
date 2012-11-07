# encoding: UTF-8

class AddNeedsHpvToCases < ActiveRecord::Migration
  def self.up
    add_column :cases, :needs_hpv, :boolean, :default => false
  end

  def self.down
    remove_column :cases, :needs_hpv
  end
end
