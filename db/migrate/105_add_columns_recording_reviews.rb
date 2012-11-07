# encoding: UTF-8

class AddColumnsRecordingReviews < ActiveRecord::Migration
  def self.up
    add_column :cases, :review_by, :integer
    add_column :cases, :review_at, :datetime
  end

  def self.down
    remove_column :cases, :review_by
    remove_column :cases, :review_at
  end
end
