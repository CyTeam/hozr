class CreateCytoExaminationMethods < ActiveRecord::Migration
  def self.up
    create_table :examination_methods do |t|
      t.column :name, :string
    end
  end

  def self.down
    drop_table :examination_methods
  end
end
