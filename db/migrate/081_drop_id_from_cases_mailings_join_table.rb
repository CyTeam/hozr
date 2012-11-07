# encoding: UTF-8

class DropIdFromCasesMailingsJoinTable < ActiveRecord::Migration
  def self.up
    remove_column :cases_mailings, :id
  end

  def self.down
  end
end
