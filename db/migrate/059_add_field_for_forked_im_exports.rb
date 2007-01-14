class AddFieldForForkedImExports < ActiveRecord::Migration
  def self.up
    add_column :exports, :pid, :integer
    add_column :imports, :pid, :integer
  end

  def self.down
    remove_column :exports, :pid
    remove_column :imports, :pid
  end
end
