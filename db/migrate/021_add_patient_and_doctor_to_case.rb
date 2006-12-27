class AddPatientAndDoctorToCase < ActiveRecord::Migration
  def self.up
    add_column :cases, :patient_id, :integer
    add_column :cases, :doctor_id, :integer
  end

  def self.down
    remove_column :cases, :patient_id
    remove_column :cases, :doctor_id
  end
end
