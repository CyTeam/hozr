# encoding: UTF-8

class AddDefaultForErrorIdsInImexport < ActiveRecord::Migration
  def self.up
    change_column_default :imports, :error_ids, ""
    change_column_default :exports, :error_ids, ""
  end

  def self.down
  end
end
