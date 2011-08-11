class PortInsuranceVcards < ActiveRecord::Migration
  def self.up
    Insurance.connection.execute("UPDATE vcards INNER JOIN insurances ON vcards.id = insurances.vcard_id SET vcards.object_type = 'Insurance', vcards.object_id = insurances.id")
    
    remove_column :insurances, :vcard_id
  end

  def self.down
  end
end
