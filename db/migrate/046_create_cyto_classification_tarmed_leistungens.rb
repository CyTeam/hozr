class CreateCytoClassificationTarmedLeistungens < ActiveRecord::Migration
  def self.up
    create_table :classification_tarmed_leistungens do |t|
      t.column :classification_id, :integer
      t.column :tarmed_leistung_id, :string
    end
  end

  def self.down
    drop_table :classification_tarmed_leistungens
  end
end
