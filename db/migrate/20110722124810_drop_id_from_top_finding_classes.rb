class DropIdFromTopFindingClasses < ActiveRecord::Migration
  def self.up
    remove_column :top_finding_classes, :id
  end

  def self.down
  end
end
