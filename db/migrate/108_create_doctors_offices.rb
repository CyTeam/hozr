# encoding: UTF-8

class CreateDoctorsOffices < ActiveRecord::Migration
  def self.up
    create_table :doctors_offices do |t|
      t.column :office_id, :integer
      t.column :doctor_id, :integer
    end
  end

  def self.down
    drop_table :doctors_offices
  end
end
