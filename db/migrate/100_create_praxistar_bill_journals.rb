class CreatePraxistarBillJournals < ActiveRecord::Migration
  def self.up
    create_table :praxistar_bill_journals do |t|
    end
  end

  def self.down
    drop_table :praxistar_bill_journals
  end
end
