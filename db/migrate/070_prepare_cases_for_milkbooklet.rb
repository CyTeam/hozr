class PrepareCasesForMilkbooklet < ActiveRecord::Migration
  def self.up
    add_column :cases, :assigned_at, :datetime
    add_column :cases, :assigned_screener_id, :datetime
    add_column :cases, :intra_day_id, :integer
  end

  def self.down
    remove_column :cases, :assigned_at
    remove_column :cases, :assigned_screener_id
    remove_column :cases, :intra_day_id
  end
end
