class InsuranceNrIsNotGuaranteedToBeANumber < ActiveRecord::Migration
  def self.up
    change_column :patients, :insurance_nr, :string
  end

  def self.down
    change_column :patients, :insurance_nr, :integer
  end
end
