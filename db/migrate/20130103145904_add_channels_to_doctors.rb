class AddChannelsToDoctors < ActiveRecord::Migration
  def change
    add_column :doctors, :channels, :text
  end
end
