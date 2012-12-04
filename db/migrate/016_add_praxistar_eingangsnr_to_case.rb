# encoding: UTF-8

class AddPraxistarEingangsnrToCase < ActiveRecord::Migration
  def self.up
    add_column :cases, :praxistar_eingangsnr, :string, :limit => 8
  end

  def self.down
    remove_column :cases, :praxistar_eingangsnr
  end
end
