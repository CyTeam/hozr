class AddRemarksToPatients < ActiveRecord::Migration
  def self.up
    add_column :patients, :remarks, :text
  end

  def self.down
    remove_column :patients, :remarks
  end
end
