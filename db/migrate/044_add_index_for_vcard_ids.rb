# encoding: UTF-8

class AddIndexForVcardIds < ActiveRecord::Migration
  def self.up
    add_index :addresses, :vcard_id
    add_index :phone_numbers, :vcard_id
  end

  def self.down
    remove_index :addresses, :vcard_id
    remove_index :phone_numbers, :vcard_id
  end
end
