class AddDeceasedRemarksToPatient < ActiveRecord::Migration
  def self.up
    add_column :patients, :deceased, :boolean
  end

  def self.down
    remove_column :patients, :deceased
  end
end
