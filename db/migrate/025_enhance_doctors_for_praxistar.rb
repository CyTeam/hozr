# encoding: UTF-8

class EnhanceDoctorsForPraxistar < ActiveRecord::Migration
  def self.up
    add_column :doctors, :code, :string
    add_column :doctors, :field, :string
  end

  def self.down
    remove_column :doctors, :code
    remove_column :doctors, :field
  end
end
