# encoding: UTF-8

class CreateTasks < ActiveRecord::Migration
  def self.up
    create_table :tasks do |t|
      t.column :created_at, :datetime
      t.column :updated_at, :datetime
      t.column :due_on, :datetime
      t.column :amount, :integer
    end
  end

  def self.down
    drop_table :tasks
  end
end
