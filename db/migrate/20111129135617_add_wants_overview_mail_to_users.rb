class AddWantsOverviewMailToUsers < ActiveRecord::Migration
  def self.up
    add_column :users, :wants_overview_email, :boolean, :default => false
  end

  def self.down
    remove_column :users, :wants_overview_email
  end
end
