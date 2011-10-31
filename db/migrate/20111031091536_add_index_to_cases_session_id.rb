class AddIndexToCasesSessionId < ActiveRecord::Migration
  def self.up
    add_index :cases, :session_id
  end

  def self.down
    remove_index :cases, :session_id
  end
end
