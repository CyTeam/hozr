class CreatePraxistarPayments < ActiveRecord::Migration
  def self.up
    create_table :payments do |t|
      # t.column :name, :string
    end
  end

  def self.down
    drop_table :payments
  end
end
