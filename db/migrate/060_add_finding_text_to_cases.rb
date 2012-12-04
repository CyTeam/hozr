# encoding: UTF-8

class AddFindingTextToCases < ActiveRecord::Migration
  def self.up
    add_column :cases, :finding_text, :text
  end

  def self.down
    remove_column :cases, :finding_text
  end
end
