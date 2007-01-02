class AddDeceasedRemarksToPatient < ActiveRecord::Migration
  def self.up
    add_column :patients, :deceased, :boolean
    add_column :patients, :remarks, :string
  end

  def self.down
    remove_column :patients, :deceased
    remove_column :patients, :remarks
  end
end
