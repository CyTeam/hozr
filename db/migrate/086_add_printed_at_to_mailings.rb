# encoding: UTF-8

class AddPrintedAtToMailings < ActiveRecord::Migration
  def self.up
    add_column :mailings, :printed_at, :datetime
  end

  def self.down
    remove_column :mailings, :printed_at
  end
end
