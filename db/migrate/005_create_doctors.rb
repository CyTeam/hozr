class CreateDoctors < ActiveRecord::Migration
  def self.up
    create_table :doctors do |t|
      t.column "vcard_id", :integer
    end
  end

  def self.down
    drop_table :doctors
  end
end
