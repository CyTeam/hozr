class DropIdInDoctorsOffices < ActiveRecord::Migration
  def self.up
    remove_column :doctors_offices, :id
  end

  def self.down
  end
end
