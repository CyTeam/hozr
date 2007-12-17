class AddEmployeeIdToTasks < ActiveRecord::Migration
  def self.up
    add_column :tasks, :employee_id, :integer
  end

  def self.down
    remove_column :tasks, :employee_id
  end
end
