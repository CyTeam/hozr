class CreatePatients < ActiveRecord::Migration
  def self.up
    create_table :patients do |t|
      t.column "vcard_id", :integer
      t.column "birth_date", :date
      t.column "insurance_id", :integer
      t.column "insurance_nr", :integer
      t.column "sex", :integer
      t.column "only_year_of_birth", :integer
      t.column "doctor_id", :integer
      t.column "billing_vcard_id", :integer
    end
  end

  def self.down
    drop_table :patients
  end
end
