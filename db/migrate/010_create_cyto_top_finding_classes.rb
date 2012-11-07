# encoding: UTF-8

class CreateCytoTopFindingClasses < ActiveRecord::Migration
  def self.up
    create_table :top_finding_classes do |t|
      t.column "classification_id", :integer
      t.column "finding_class_id", :integer
    end
  end

  def self.down
    drop_table :top_finding_classes
  end
end
