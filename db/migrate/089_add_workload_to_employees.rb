# encoding: UTF-8

class AddWorkloadToEmployees < ActiveRecord::Migration
  def self.up
    add_column :employees, :workload, :float
  end

  def self.down
    remove_column :employees, :workload
  end
end
