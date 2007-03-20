class PrepareCasesForMilkbooklet < ActiveRecord::Migration
  def self.up
    add_column :cases, :assigned_at, :datetime
    add_column :cases, :assigned_screener_id, :datetime
    add_column :cases, :intra_day_id, :integer
  
    Cyto::Case.update_all "assigned_at = created_at"
  end

  def self.down
    remove_column :cases, :assigned_at
    remove_column :cases, :assigned_screener_id
    remove_column :cases, :intra_day_id
  end
end
