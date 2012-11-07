# encoding: UTF-8

class CreatePraxistarImports < ActiveRecord::Migration
  def self.up
    create_table :imports do |t|
      t.column :started_at, :datetime
      t.column :finished_at, :datetime
      t.column :update_count, :integer, :default => 0
      t.column :create_count, :integer, :default => 0
      t.column :error_count, :integer, :default => 0
      t.column :error_ids, :string
      t.column :model, :string
      t.column :find_params, :string
    end
  end

  def self.down
    drop_table :imports
  end
end
