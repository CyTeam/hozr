class RenameMethodIdToExaminationMethodIdInClassifications < ActiveRecord::Migration
  def self.up
    rename_column :classifications, :method_id, :examination_method_id
  end

  def self.down
    rename_column :classifications, :examination_method_id, :method_id
  end
end
