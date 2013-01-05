class AddDefaultToClassifications < ActiveRecord::Migration
  def change
    add_column :classifications, :default, :boolean, :default => false
  end
end
