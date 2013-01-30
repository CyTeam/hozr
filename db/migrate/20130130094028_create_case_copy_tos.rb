class CreateCaseCopyTos < ActiveRecord::Migration
  def change
    create_table :case_copy_tos do |t|
      t.references :case
      t.references :person
      t.text :channels

      t.timestamps
    end
    add_index :case_copy_tos, :case_id
    add_index :case_copy_tos, :person_id
  end
end
