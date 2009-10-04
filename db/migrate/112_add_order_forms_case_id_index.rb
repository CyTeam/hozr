class AddOrderFormsCaseIdIndex < ActiveRecord::Migration
  def self.up
    add_index :order_forms, :case_id
  end

  def self.down
  end
end
