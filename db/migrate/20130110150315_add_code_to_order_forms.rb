class AddCodeToOrderForms < ActiveRecord::Migration
  def change
    add_column :order_forms, :code, :string
  end
end
