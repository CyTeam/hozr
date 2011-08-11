class PortDoctorVcards < ActiveRecord::Migration
  def self.up
    Doctor.update_all("private_vcard = NULL", "private_vcard = praxis_vcard")

    Doctor.connection.execute("UPDATE vcards INNER JOIN doctors ON vcards.id = doctors.private_vcard SET vcards.object_type = 'Doctor', vcards.object_id = doctors.id, vcards.vcard_type = 'private'")
    Doctor.connection.execute("UPDATE vcards INNER JOIN doctors ON vcards.id = doctors.praxis_vcard SET vcards.object_type = 'Doctor', vcards.object_id = doctors.id, vcards.vcard_type = 'praxis'")
    
    remove_column :doctors, :praxis_vcard
    remove_column :doctors, :private_vcard
  end

  def self.down
  end
end
