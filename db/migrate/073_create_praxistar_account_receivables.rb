class CreatePraxistarAccountReceivables < ActiveRecord::Migration
  def self.up
    create_table :account_receivables do |t|
      # t.column :name, :string
    end
  end

  def self.down
    drop_table :account_receivables
  end
end
