class AddDoctorPatientNrForPatients < ActiveRecord::Migration
  def self.up
    add_column :patients, :doctor_patient_nr, :string
  end

  def self.down
    remove_column :patients, :doctor_patient_nr
  end
end
