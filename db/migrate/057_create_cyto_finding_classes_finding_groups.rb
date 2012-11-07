# encoding: UTF-8

class CreateCytoFindingClassesFindingGroups < ActiveRecord::Migration
  def self.up
    create_table :finding_classes_finding_groups, :id => false do |t|
      t.column :finding_class_id, :integer
      t.column :finding_group_id, :integer
    end
  end

  def self.down
    drop_table :finding_classes_finding_groups
  end
end
