class CreateHonorificPrefixes < ActiveRecord::Migration
  def self.up
    create_table :honorific_prefixes do |t|
      t.column :sex, :integer
      t.column :name, :string
    end
  end

  def self.down
    drop_table :honorific_prefixes
  end
end
