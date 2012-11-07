# encoding: UTF-8

class DoctorsPasswordCanBeNull < ActiveRecord::Migration
  def self.up
    change_column :doctors, :password, :string, :null => true
  end

  def self.down
  end
end
