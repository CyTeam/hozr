class CreatePostalCodes < ActiveRecord::Migration
  def self.up
    create_table "postal_codes" do |t|
      t.string   "zip_type"
      t.string   "zip"
      t.string   "zip_extension"
      t.string   "locality"
      t.string   "locality_long"
      t.string   "canton"
      t.integer  "imported_id"

      t.timestamps
    end
  end

  def self.down
    drop_table :postal_codes
  end
end
