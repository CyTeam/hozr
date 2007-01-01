class AddScreenerToCase < ActiveRecord::Migration
  def self.up
    add_column :cases, :screener, :string
  end

  def self.down
    remove_column
  end
end
