class AddClassificationToCase < ActiveRecord::Migration
  def self.up
    add_column :cases, :classification_id, :integer
  end

  def self.down
    remove_column :cases, :classification_id
  end
end
