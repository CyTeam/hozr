class AddFieldsToPatientsForPraxistarImport < ActiveRecord::Migration
  def self.up
    add_column :patients, :created_at, :datetime
    add_column :patients, :updated_at, :datetime
    add_column :patients, :remarks, :string
    add_column :patients, :dunning_stop, :boolean
    add_column :patients, :use_billing_address, :boolean
  end

  def self.down
    remove_column :patients, :created_at
    remove_column :patients, :updated_at
    remove_column :patients, :remarks
    remove_column :patients, :dunning_stop
    remove_column :patients, :use_billing_address
  end
end
