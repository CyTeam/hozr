class AddBillIdToDelieveryReturns < ActiveRecord::Migration
  def self.up
    add_column :delievery_returns, :bill_id, :integer
  end

  def self.down
    remove_column :delievery_returns, :bill_id
  end
end
