class DropTablePostalcodes < ActiveRecord::Migration
  def up
    drop_table :postal_codes
  end
end
