class AddAddressVerifiedAtToDelieveryReturns < ActiveRecord::Migration
  def self.up
    add_column :delievery_returns, :address_verified_at, :datetime
  end

  def self.down
    remove_column :delievery_returns, :address_verified_at
  end
end
