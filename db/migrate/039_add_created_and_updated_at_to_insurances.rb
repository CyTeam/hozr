class AddCreatedAndUpdatedAtToInsurances < ActiveRecord::Migration
  def self.up
    add_column :insurances, :created_at, :datetime
    add_column :insurances, :updated_at, :datetime
  end

  def self.down
    remove_column :insurances, :created_at
    remove_column :insurances, :updated_at
  end
end
