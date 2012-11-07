# encoding: UTF-8

class AddClosedAtToDelieveryReturns < ActiveRecord::Migration
  def self.up
    add_column :delievery_returns, :closed_at, :datetime
  end

  def self.down
    remove_column :delievery_returns, :closed_at
  end
end
