class CreateInsurances < ActiveRecord::Migration
  def self.up
    create_table :insurances do |t|
      t.column "vcard_id", :integer
    end
  end

  def self.down
    drop_table :insurances
  end
end
