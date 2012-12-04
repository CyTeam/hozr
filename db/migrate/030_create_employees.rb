# encoding: UTF-8

class CreateEmployees < ActiveRecord::Migration
  def self.up
    create_table :employees do |t|
      t.column :work_vcard_id, :integer
      t.column :private_vcard_id, :integer
      t.column :code, :string
    end
  end

  def self.down
    drop_table :employees
  end
end
