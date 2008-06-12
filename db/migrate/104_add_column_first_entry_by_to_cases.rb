class AddColumnFirstEntryByToCases < ActiveRecord::Migration
  def self.up
    add_column :cases, :first_entry_by, :integer
    add_column :cases, :first_entry_at, :datetime
  end

  def self.down
    remove_column :cases, :first_entry_by
    remove_column :cases, :first_entry_at
  end
end
