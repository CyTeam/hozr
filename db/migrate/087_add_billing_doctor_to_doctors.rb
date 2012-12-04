# encoding: UTF-8

class AddBillingDoctorToDoctors < ActiveRecord::Migration
  def self.up
    add_column :doctors, :billing_doctor_id, :integer
  end

  def self.down
    remove_column :doctors, :billing_doctor_id
  end
end
