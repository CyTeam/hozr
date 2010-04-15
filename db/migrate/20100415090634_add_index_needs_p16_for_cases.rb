class AddIndexNeedsP16ForCases < ActiveRecord::Migration
  def self.up
    add_index :cases, :needs_p16
    add_index :cases, :screened_at
  end

  def self.down
    remove_index :cases, :needs_p16
    remove_index :cases, :screened_at
  end
end
