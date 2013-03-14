class AddIndexOnTreatmentsImportedId < ActiveRecord::Migration
  def up
    add_index :treatments, :imported_id
  end
end
