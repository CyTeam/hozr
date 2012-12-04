# encoding: UTF-8

class DropTasksAndSchedules < ActiveRecord::Migration
  def self.up
    drop_table :tasks
    remove_column :cases, :scheduled_at
    remove_column :cases, :scheduled_for
    remove_column :cases, :centrifuged_at
    remove_column :cases, :centrifuged_by
  end

  def self.down
  end
end
