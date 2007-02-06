class AddActiveFieldForDoctors < ActiveRecord::Migration
  def self.up
    add_column :doctors, :active, :boolean, :default => true
    Doctor.update_all([ 'active = ?', true])
  end

  def self.down
    remove_column :doctors, :active
  end
end
