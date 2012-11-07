# encoding: UTF-8

class AddClassificationGroupIdToClassifications < ActiveRecord::Migration
  def self.up
    add_column :classifications, :classification_group_id, :integer
  end

  def self.down
    remove_column :classifications, :classification_group_id
  end
end
