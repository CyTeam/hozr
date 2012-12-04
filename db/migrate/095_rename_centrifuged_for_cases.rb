# encoding: UTF-8

class RenameCentrifugedForCases < ActiveRecord::Migration
  def self.up
    rename_column :cases, :centrifuged_for, :centrifuged_by
  end

  def self.down
    rename_column :cases, :centrifuged_by, :centrifuged_for
  end
end
