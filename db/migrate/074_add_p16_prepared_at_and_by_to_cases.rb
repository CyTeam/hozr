class AddP16PreparedAtAndByToCases < ActiveRecord::Migration
  def self.up
    add_column :cases, :p16_prepared_at, :datetime
    add_column :cases, :p16_prepared_by, :integer
  end

  def self.down
    remove_column :cases, :p16_prepared_at
    remove_column :cases, :p16_prepared_by
  end
end
