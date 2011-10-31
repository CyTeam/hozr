class AddIndexToCasesReviewAt < ActiveRecord::Migration
  def self.up
    add_index :cases, :review_at
  end

  def self.down
    remove_index :cases, :review_at
  end
end
