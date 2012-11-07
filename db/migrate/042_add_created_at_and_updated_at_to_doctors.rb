# encoding: UTF-8

class AddCreatedAtAndUpdatedAtToDoctors < ActiveRecord::Migration
  def self.up
    add_column :doctors, :created_at, :datetime
    add_column :doctors, :updated_at, :datetime
  end

  def self.down
    remove_column :doctors, :created_at
    remove_column :doctors, :updated_at
  end
end
