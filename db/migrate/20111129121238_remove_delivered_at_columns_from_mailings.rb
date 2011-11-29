class RemoveDeliveredAtColumnsFromMailings < ActiveRecord::Migration
  def self.up
    remove_column :mailings, :printed_at
    remove_column :mailings, :email_delivered_at
    remove_column :mailings, :hl7_delivered_at
  end

  def self.down
    add_column :mailings, :hl7_delivered_at, :datetime
    add_column :mailings, :email_delivered_at, :datetime
    add_column :mailings, :printed_at, :datetime
  end
end
