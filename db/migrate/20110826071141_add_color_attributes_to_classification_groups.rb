class AddColorAttributesToClassificationGroups < ActiveRecord::Migration
  def self.up
    add_column :classification_groups, :color, :string
    add_column :classification_groups, :print_color, :string
  end

  def self.down
    remove_column :classification_groups, :color
    remove_column :classification_groups, :print_color
  end
end
