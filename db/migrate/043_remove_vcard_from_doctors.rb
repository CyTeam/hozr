class RemoveVcardFromDoctors < ActiveRecord::Migration
  def self.up
    remove_column :doctors, :vcard_id
  end

  def self.down
    add_column :doctors, :vcard_id, :integer
  end
end
