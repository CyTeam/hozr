# encoding: utf-8

class Slidepath::LocationIndex < ActiveRecord::Base
  # Legacy specs
  begin
    use_db :prefix => 'slidepath_'
  rescue
  end
  self.table_name = 'location_index'
  self.primary_key = 'locationId'

  # Case
  def a_case
    Case.find_by_id(fileName.first(6))
  end
end
