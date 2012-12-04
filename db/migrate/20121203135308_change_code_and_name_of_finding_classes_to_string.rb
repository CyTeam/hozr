class ChangeCodeAndNameOfFindingClassesToString < ActiveRecord::Migration
  def up
    change_column :finding_classes, :name, :string
    change_column :finding_classes, :code, :string
  end
end
