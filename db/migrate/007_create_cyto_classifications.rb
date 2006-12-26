class CreateCytoClassifications < ActiveRecord::Migration
  def self.up
    create_table :classifications do |t|
      t.column "name", :text
      t.column "color", :string, :limit => 7
    end
  end

  def self.down
    drop_table :classifications
  end
end
