class DropUnusedTables < ActiveRecord::Migration
  def self.up
    # Unused tables
    drop_table :payments
    drop_table :account_receivables
    drop_table :praxistar_bill_journals
    drop_table :scans
    drop_table :shop_orders

    # Deprecated tables
    drop_table :schema_info
  end

  def self.down
  end
end
