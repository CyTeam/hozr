class CreatePhoneNumbers < ActiveRecord::Migration
  def self.up
    create_table :phone_numbers do |t|
      t.column "number", :string, :limit => 50
      t.column "phone_number_type", :string, :limit => 50
      t.column "vcard_id", :integer
    end
  end

  def self.down
    drop_table :phone_numbers
  end
end
