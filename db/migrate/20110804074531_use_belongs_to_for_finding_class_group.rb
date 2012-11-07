# encoding: UTF-8

class UseBelongsToForFindingClassGroup < ActiveRecord::Migration
  def self.up
    add_column :finding_classes, :finding_group_id, :integer
    add_index :finding_classes, :finding_group_id
    
    for finding_class in FindingClass.all
      finding_class.finding_group = finding_class.finding_groups.first
      finding_class.save
    end
  end

  def self.down
    remove_column :finding_classes, :finding_group_id
  end
end
