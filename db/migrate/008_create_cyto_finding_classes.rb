class CreateCytoFindingClasses < ActiveRecord::Migration
  def self.up
    create_table :finding_classes do |t|
      t.column "name", :text
      t.column "code", :text
    end
  end

  def self.down
    drop_table :finding_classes
  end
end
