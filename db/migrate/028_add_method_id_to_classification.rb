# encoding: UTF-8

class AddMethodIdToClassification < ActiveRecord::Migration
  def self.up
    add_column :classifications, :method_id, :integer
  end

  def self.down
    remove_column :classifications, :method_id
  end
end
