class ChangeTitleFindingClassColumnToText < ActiveRecord::Migration
  def up
    change_column :finding_classes, :name, :text
  end
end
