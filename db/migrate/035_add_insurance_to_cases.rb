# encoding: UTF-8

class AddInsuranceToCases < ActiveRecord::Migration
  def self.up
    add_column :cases, :insurance_id, :integer
    add_column :cases, :insurance_nr, :string
  end

  def self.down
    remove_column :cases, :insurance_id
    remove_column :cases, :insurance_nr
  end
end
