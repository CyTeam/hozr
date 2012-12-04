# encoding: UTF-8

class ScreenerIsForeignKey < ActiveRecord::Migration
  def self.up
    rename_column :cases, :screener, :screener_id
    change_column :cases, :screener_id, :integer
  end

  def self.down
    change_column :cases, :screener_id, :string
    rename_column :cases, :screener_id, :screener
  end
end
