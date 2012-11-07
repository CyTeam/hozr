# encoding: UTF-8

class CreateInsurancePolicies < ActiveRecord::Migration
  def self.up
    Patient.connection.execute(
      "INSERT INTO insurance_policies (patient_id, insurance_id, number, policy_type) SELECT id, insurance_id, insurance_nr, 'KVG' FROM patients"
    )
  end

  def self.down
  end
end
