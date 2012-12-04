# encoding: UTF-8

class CreateCytoCases < ActiveRecord::Migration
  def self.up
    create_table :cases do |t|
      t.column :method_id, :integer
      t.column :examination_date, :date
    end
  end

  def self.down
    drop_table :cases
  end
end
