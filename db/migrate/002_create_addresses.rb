class CreateAddresses < ActiveRecord::Migration
  def self.up
    create_table :addresses do |t|
      t.column "post_office_box", :string, :limit => 50
      t.column "extended_address", :string, :limit => 50
      t.column "street_address", :string, :limit => 50
      t.column "locality", :string, :limit => 50
      t.column "region", :string, :limit => 50
      t.column "postal_code", :string, :limit => 50
      t.column "country_name", :string, :limit => 50
      t.column "type", :string, :limit => nil
      t.column "vcard_id", :integer
      t.column "address_type", :string, :limit => nil
    end
  end

  def self.down
    drop_table :addresses
  end
end
