class AddEmailSentAtToCases < ActiveRecord::Migration
  def self.up
    add_column :cases, :email_sent_at, :datetime
    Cyto::Case.update_all "email_sent_at = '2000-01-01'"
  end

  def self.down
    remove_column :cases, :email_sent_at
  end
end
