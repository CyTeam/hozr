class CreateDelieveryReturns < ActiveRecord::Migration
  def self.up
    create_table :delievery_returns do |t|
      t.column :case_id, :integer
      t.column :fax_sent_at, :datetime
    end
  end

  def self.down
    drop_table :delievery_returns
  end
end
