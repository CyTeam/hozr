# encoding: UTF-8

class AddIndexForCases < ActiveRecord::Migration
  def self.up
    add_index :cases, :patient_id
    add_index :cases, :doctor_id
    add_index :cases, :insurance_id
  end

  def self.down
    remove_index :cases, :patient_id
    remove_index :cases, :doctor_id
    remove_index :cases, :insurance_id
  end
end
