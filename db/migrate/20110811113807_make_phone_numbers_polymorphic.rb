# encoding: UTF-8

class MakePhoneNumbersPolymorphic < ActiveRecord::Migration
  def self.up
    PhoneNumber.update_all "object_id = vcard_id, object_type = 'Vcard'"

    remove_column :phone_numbers, :vcard_id
   end

  def self.down
  end
end
