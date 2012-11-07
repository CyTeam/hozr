# encoding: UTF-8

class DropInsuranceColumnsInPatient < ActiveRecord::Migration
  def self.up
    remove_column :patients, :insurance_id
    remove_column :patients, :insurance_nr
  end

  def self.down
  end
end
