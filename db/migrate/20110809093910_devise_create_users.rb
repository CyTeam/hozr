# encoding: UTF-8

class DeviseCreateUsers < ActiveRecord::Migration
  def self.up
    change_table(:users) do |t|
      t.string :encrypted_password, :null => false, :default => '', :limit => 128
      t.trackable
      t.lockable :lock_strategy => :failed_attempts, :unlock_strategy => :both
    end

    add_index :users, :email
    add_index :users, :unlock_token,         :unique => true
  end

  def self.down
    drop_table :users
  end
end
