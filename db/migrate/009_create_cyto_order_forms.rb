# encoding: UTF-8

class CreateCytoOrderForms < ActiveRecord::Migration
  def self.up
    create_table :order_forms do |t|
      t.column "file", :text
      t.column "created_at", :datetime
    end
  end

  def self.down
    drop_table :order_forms
  end
end
