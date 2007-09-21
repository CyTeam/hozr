class CreateClassificationGroups < ActiveRecord::Migration
  def self.up
    create_table :classification_groups do |t|
      t.column :title, :string
      t.column :position, :integer
    end
  end

  def self.down
    drop_table :classification_groups
  end
end
