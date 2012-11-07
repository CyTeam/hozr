# encoding: UTF-8

class DropImportsTable < ActiveRecord::Migration
  def self.up
    drop_table :imports
  end

  def self.down
  end
end
