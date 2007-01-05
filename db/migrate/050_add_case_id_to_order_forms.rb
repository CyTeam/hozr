class AddCaseIdToOrderForms < ActiveRecord::Migration
  def self.up
    add_column :order_forms, :case_id, :integer
  end

  def self.down
    remove_column :oder_forms, :case_id
  end
end
