class AllowNullInCases < ActiveRecord::Migration
  def self.up
    change_column :cases, :doctor_id, :integer, :null => true
    change_column :cases, :patient_id, :integer, :null => true
    change_column :cases, :examination_date, :date, :null => true
    change_column :cases, :examination_method_id, :integer, :null => true
  end

  def self.down
      change_column :cases, :doctor_id, :integer, :null => false
      change_column :cases, :patient_id, :integer, :null => false
      change_column :cases, :examination_date, :date, :null => false
      change_column :cases, :examination_method_id, :integer, :null => false
  end
end
