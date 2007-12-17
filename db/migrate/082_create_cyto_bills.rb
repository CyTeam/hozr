class CreateCytoBills < ActiveRecord::Migration
  def self.up
    # Drop bills table from 071
#    drop_table :bills
    
    create_table :bills do |t|
      t.column "case_id", :integer
      t.column "amount", :float
      t.column "created_at", :datetime
      t.column "updated_at", :datetime
      t.column "is_storno", :boolean
      t.column "praxistar_rechnungs_id", :integer
      t.column "praxistar_leistungsblatt_id", :integer
    end
  end

  def self.down
    drop_table :bills
  end
end
