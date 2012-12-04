# encoding: UTF-8

class AddIndexToMailingsDoctorId < ActiveRecord::Migration
  def self.up
    add_index :mailings, :doctor_id
  end

  def self.down
    remove_index :mailings, :doctor_id
  end
end
