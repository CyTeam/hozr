class CreateInsurancePolicies < ActiveRecord::Migration
  def self.up
    for patient in Patient.all
      puts patient

      policy = patient.insurance_policies.build

      policy.insurance_id = patient.insurance_id
      policy.number       = patient.insurance_nr
      policy.policy_type  = "KVG"
      
      patient.save(:validate => false)
    end
  end

  def self.down
  end
end
