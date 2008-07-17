class CreateOffices < ActiveRecord::Migration
  def self.up
    create_table :offices do |t|
      t.column :name, :string
      t.column :login, :string
      t.column :password, :string
    end
  end

  def self.down
    drop_table :offices
  end
end
