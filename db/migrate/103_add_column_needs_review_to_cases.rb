# encoding: UTF-8

class AddColumnNeedsReviewToCases < ActiveRecord::Migration
  def self.up
    add_column :cases, :needs_review, :boolean, :default => false
  end

  def self.down
    remove_column :cases, :needs_review
  end
end
