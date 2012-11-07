# encoding: UTF-8

class CreateCytoFindingGroups < ActiveRecord::Migration
  def self.up
    create_table :finding_groups do |t|
      t.column :name, :string
    end
  end

  def self.down
    drop_table :finding_groups
  end
end
