# encoding: UTF-8

class AddPraxistarLeistungsblattIdAndScreeningDateToCases < ActiveRecord::Migration
  def self.up
    add_column :cases, :praxistar_leistungsblatt_id, :integer
    add_column :cases, :screened_at, :datetime
  end

  def self.down
    remove_column :cases, :praxistar_leistungsblatt_id
    remove_column :cases, :screened_at
  end
end
