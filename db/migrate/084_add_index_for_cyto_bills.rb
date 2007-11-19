class AddIndexForCytoBills < ActiveRecord::Migration
  def self.up
    add_index :bills, :case_id
    add_index :bills, :praxistar_rechnungs_id
    add_index :bills, :praxistar_leistungsblatt_id
  end

  def self.down
    remove_index :bills, :case_id
    remove_index :bills, :praxistar_rechnungs_id
    remove_index :bills, :praxistar_leistungsblatt_id
  end
end
