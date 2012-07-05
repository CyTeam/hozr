# encoding: utf-8

class Slidepath::LocationIndex < ActiveRecord::Base
  # Legacy specs
  use_db :prefix => 'slidepath_'
  set_table_name 'location_index'
  set_primary_key 'locationId'

  # Case
  def a_case
    Case.find_by_id(fileName.first(6))
  end
end
