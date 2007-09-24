class CreateMailings < ActiveRecord::Migration
  def self.up
    create_table :mailings do |t|
      t.column :created_at, :datetime
      t.column :doctor_id, :integer
    end
  end

  def self.down
    drop_table :mailings
  end
end
