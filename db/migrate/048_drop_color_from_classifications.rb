# encoding: UTF-8

class DropColorFromClassifications < ActiveRecord::Migration
  def self.up
    remove_column :classifications, :color
  end

  def self.down
    add_column :classifications, :color, :string
  end
end
