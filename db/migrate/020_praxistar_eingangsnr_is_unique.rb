class PraxistarEingangsnrIsUnique < ActiveRecord::Migration
  def self.up
    add_index :cases, :praxistar_eingangsnr, :unique => true
  end

  def self.down
    remove_index :cases, :praxistar_eingangsnr
  end
end
