class AddCodeToClassifications < ActiveRecord::Migration
  def self.up
    add_column :classifications, :code, :string, :limit => 10
  end

  def self.down
    remove_column :classifications, :code
  end
end
