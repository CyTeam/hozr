# encoding: UTF-8

class PortPatientToVcard < ActiveRecord::Migration
  def self.up
    Patient.update_all("billing_vcard_id = NULL", "billing_vcard_id = vcard_id")

    Patient.connection.execute("UPDATE vcards INNER JOIN patients ON vcards.id = patients.billing_vcard_id SET vcards.object_type = 'Patient', vcards.object_id = patients.id, vcards.vcard_type = 'billing'")
    Patient.connection.execute("UPDATE vcards INNER JOIN patients ON vcards.id = patients.vcard_id SET vcards.object_type = 'Patient', vcards.object_id = patients.id, vcards.vcard_type = 'private'")
    
    remove_column :patients, :vcard_id
    remove_column :patients, :billing_vcard_id
  end

  def self.down
  end
end
