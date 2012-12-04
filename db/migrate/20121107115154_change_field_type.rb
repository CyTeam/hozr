class ChangeFieldType < ActiveRecord::Migration
  def up
    change_column :classifications, :name, :string
  end

  def down
    change_column :classifications, :name, :text
  end
end
