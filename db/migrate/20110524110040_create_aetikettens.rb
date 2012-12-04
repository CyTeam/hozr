# encoding: UTF-8

class CreateAetikettens < ActiveRecord::Migration
  def self.up
    create_table :aetikettens do |t|
      t.string :hon_suffix
      t.string :fam_name
      t.string :giv_name
      t.string :ext_address
      t.string :loc
      t.string :postc

      t.timestamps
    end
  end

  def self.down
    drop_table :aetikettens
  end
end
