class AddPositionToCasesFindingClasses < ActiveRecord::Migration
  def self.up
    add_column :cases_finding_classes, :position, :integer
    remove_column :cases_finding_classes, :order
  end

  def self.down
    remove_column :cases_finding_classes, :position
    add_column :cases_finding_classes, :order, :integer
  end
end
