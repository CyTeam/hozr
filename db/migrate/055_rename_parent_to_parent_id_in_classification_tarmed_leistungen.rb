class RenameParentToParentIdInClassificationTarmedLeistungen < ActiveRecord::Migration
  def self.up
    rename_column :classification_tarmed_leistungens, :parent, :parent_id
  end

  def self.down
    rename_column :classification_tarmed_leistungens, :parent_id, :parent
  end
end
