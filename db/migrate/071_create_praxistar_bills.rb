class CreatePraxistarBills < ActiveRecord::Migration
  def self.up
    create_table :bills do |t|
      # t.column :name, :string
    end
  end

  def self.down
    drop_table :bills
  end
end
