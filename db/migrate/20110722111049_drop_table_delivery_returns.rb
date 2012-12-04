# encoding: UTF-8

class DropTableDeliveryReturns < ActiveRecord::Migration
  def self.up
    drop_table :delievery_returns
  end

  def self.down
  end
end
