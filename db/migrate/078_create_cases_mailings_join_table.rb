class CreateCasesMailingsJoinTable < ActiveRecord::Migration
  def self.up
    create_table :cases_mailings do |t|
      t.column :case_id, :integer
      t.column :mailing_id, :integer
    end
  end

  def self.down
  end
end
