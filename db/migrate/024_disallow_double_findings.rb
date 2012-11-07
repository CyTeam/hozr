# encoding: UTF-8

class DisallowDoubleFindings < ActiveRecord::Migration
  def self.up
    add_index :cases_finding_classes, [:case_id, :finding_class_id], :unique => true
  end

  def self.down
    remove_index :cases_finding_classes, :case_id
  end
end
