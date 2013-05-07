class CreateFaxes < ActiveRecord::Migration
  def change
    create_table :faxes do |t|
      t.string :number
      t.integer :case_id
      t.integer :sender_id
      t.string :receiver_type
      t.integer :receiver_id
      t.datetime :sent_at

      t.timestamps
    end

    add_index :faxes, :case_id
    add_index :faxes, :sender_id
  end
end
