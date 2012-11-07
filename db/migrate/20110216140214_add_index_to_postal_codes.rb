# encoding: UTF-8

class AddIndexToPostalCodes < ActiveRecord::Migration
  def self.up
    add_index :postal_codes, :zip
  end

  def self.down
    remove_index :postal_codes, :zip
  end
end
