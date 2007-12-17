class AddBornOnToEmployees < ActiveRecord::Migration
  def self.up
    add_column :employees, :born_on, :date
  end

  def self.down
    remove_column :employees, :born_on
  end
end
