class CreatePages < ActiveRecord::Migration
  def self.up
    create_table :pages do |t|
      t.column :position, :integer
      t.column :scan_id, :integer
      t.column :file, :string
    end
  end

  def self.down
    drop_table :pages
  end
end
