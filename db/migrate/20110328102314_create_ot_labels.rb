# encoding: UTF-8

class CreateOtLabels < ActiveRecord::Migration
  def self.up
    create_table :ot_labels do |t|
      t.text :prax_nr
      t.integer :sys_id
      t.text :doc_fname
      t.text :doc_gname
      t.text :pat_fname
      t.text :pat_gname
      t.text :pat_bday

      t.timestamps
    end
  end

  def self.down
    drop_table :ot_labels
  end
end
