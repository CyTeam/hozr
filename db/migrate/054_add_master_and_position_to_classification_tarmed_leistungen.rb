# encoding: UTF-8

class AddMasterAndPositionToClassificationTarmedLeistungen < ActiveRecord::Migration
  def self.up
    add_column :classification_tarmed_leistungens, :position, :integer
    add_column :classification_tarmed_leistungens, :parent, :string
  end

  def self.down
    remove_column :classification_tarmed_leistungens, :position
    remove_column :classification_tarmed_leistungens, :parent
  end
end
