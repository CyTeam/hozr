# encoding: UTF-8

class AddIndexForPatientsAndDoctors < ActiveRecord::Migration
  def self.up
    add_index :patients, :vcard_id
    add_index :patients, :billing_vcard_id
    add_index :patients, :doctor_id
    add_index :patients, :insurance_id
    add_index :doctors, :praxis_vcard
    add_index :doctors, :private_vcard
  end

  def self.down
    remove_index :patients, :vcard_id
    remove_index :patients, :billing_vcard_id
    remove_index :patients, :doctor_id
    remove_index :patients, :insurance_id
    remove_index :doctors, :praxis_vcard
    remove_index :doctors, :private_vcard
  end
end
