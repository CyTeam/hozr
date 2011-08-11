class MigrateVcards < ActiveRecord::Migration
  def self.up
    # Vcards
    add_column :vcards, :active, :boolean, :default => true
    add_column :vcards, :object_id, :integer
    add_column :vcards, :object_type, :string

    add_index :vcards, [:object_id, :object_type]

    # Addresses
    remove_column :addresses, :type

    # PhoneNumbers
    add_column :phone_numbers, :object_type, :string
    add_column :phone_numbers, :object_id, :integer

    add_index :phone_numbers, [:object_id, :object_type]
  end

  def self.down
  end
end
