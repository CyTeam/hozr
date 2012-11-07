# encoding: UTF-8

class CreateCytoCasesFindingClasses < ActiveRecord::Migration
  def self.up
    create_table :cases_finding_classes do |t|
      t.column :case_id, :integer
      t.column :finding_class_id, :integer
    end
  end

  def self.down
    drop_table :cases_finding_classes
  end
end
