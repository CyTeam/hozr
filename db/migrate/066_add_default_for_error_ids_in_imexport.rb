class AddDefaultForErrorIdsInImexport < ActiveRecord::Migration
  def self.up
    change_column_default :imports, :error_ids, 0
    change_column_default :exports, :error_ids, 0
  end

  def self.down
  end
end
