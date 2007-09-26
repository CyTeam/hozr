class AddIndicesToCasesMailingsJoinTable < ActiveRecord::Migration
  def self.up
    add_index :cases_mailings, :case_id
    add_index :cases_mailings, :mailing_id
  end

  def self.down
    remove_index :cases_mailings, :case_id
    remove_index :cases_mailings, :mailing_id
  end
end
