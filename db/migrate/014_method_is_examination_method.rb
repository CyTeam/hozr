# encoding: UTF-8

class MethodIsExaminationMethod < ActiveRecord::Migration
  def self.up
    rename_column :cases, :method_id, :examination_method_id
  end

  def self.down
    rename_column :cases, :examination_method_id, :method_id
  end
end
