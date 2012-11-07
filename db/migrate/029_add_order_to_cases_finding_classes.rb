# encoding: UTF-8

class AddOrderToCasesFindingClasses < ActiveRecord::Migration
  def self.up
    add_column :cases_finding_classes, :order, :integer
  end

  def self.down
    remove_column :cases_finding_classes, :order
  end
end
