# encoding: UTF-8

class DropAddressInVcards < ActiveRecord::Migration
  def self.up
    remove_column :vcards, :address
  end

  def self.down
  end
end
