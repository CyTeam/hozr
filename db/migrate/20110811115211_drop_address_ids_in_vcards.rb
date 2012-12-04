# encoding: UTF-8

class DropAddressIdsInVcards < ActiveRecord::Migration
  def self.up
    remove_column :vcards, :billing_address_id
    remove_column :vcards, :address_id
  end

  def self.down
  end
end
