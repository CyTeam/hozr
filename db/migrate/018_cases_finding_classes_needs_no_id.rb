# encoding: UTF-8

class CasesFindingClassesNeedsNoId < ActiveRecord::Migration
  def self.up
    remove_column(:cases_finding_classes, :id)
  end

  def self.down
    raise IrreversibleMigration
  end
end
