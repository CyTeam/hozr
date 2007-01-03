class SetDefaultsForPatients < ActiveRecord::Migration
  def self.up
    change_column_default :patients, :dunning_stop, false
    change_column_default :patients, :deceased, false
    change_column_default :patients, :use_billing_address, false
  end

  def self.down
#    raise IrreversibleMigration
  end
end
