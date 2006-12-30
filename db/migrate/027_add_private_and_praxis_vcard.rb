class AddPrivateAndPraxisVcard < ActiveRecord::Migration
  def self.up
    add_column :doctors, :praxis_vcard, :integer
    add_column :doctors, :private_vcard, :integer
  end

  def self.down
    remove_column :doctors, :praxis_vcard
    remove_column :doctors, :private_vcard
  end
end
