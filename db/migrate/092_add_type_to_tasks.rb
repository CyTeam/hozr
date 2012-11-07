# encoding: UTF-8

class AddTypeToTasks < ActiveRecord::Migration
  def self.up
    add_column :tasks, :type, :text
  end

  def self.down
    remove_column :tasks, :type
  end
end
