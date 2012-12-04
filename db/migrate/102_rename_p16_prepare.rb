# encoding: UTF-8

class RenameP16Prepare < ActiveRecord::Migration
  def self.up
    rename_column :cases, :p16_prepared_at, :hpv_p16_prepared_at
    rename_column :cases, :p16_prepared_by, :hpv_p16_prepared_by
  end

  def self.down
    rename_column :cases, :hpv_p16_prepared_at, :p16_prepared_at
    rename_column :cases, :hpv_p16_prepared_by, :p16_prepared_by
  end
end
