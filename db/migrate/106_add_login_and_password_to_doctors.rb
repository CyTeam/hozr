# encoding: UTF-8

class AddLoginAndPasswordToDoctors < ActiveRecord::Migration
  def self.up
    add_column :doctors, :login, :string
    add_column :doctors, :password, :string, :null => false
  end

  def self.down
    remove_column :doctors, :login
    remove_column :doctors, :password
  end
end
