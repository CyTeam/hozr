# encoding: UTF-8

class DropHabtmTableFindingClassesFindingGroups < ActiveRecord::Migration
  def self.up
    drop_table :finding_classes_finding_groups
  end

  def self.down
  end
end
