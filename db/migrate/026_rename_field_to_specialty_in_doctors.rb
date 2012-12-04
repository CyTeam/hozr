# encoding: UTF-8

class RenameFieldToSpecialtyInDoctors < ActiveRecord::Migration
  def self.up
    rename_column :doctors, :field, :speciality
  end

  def self.down
    rename_column :doctors, :speciality, :field
  end
end
