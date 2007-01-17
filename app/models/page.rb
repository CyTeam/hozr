class Page < ActiveRecord::Base
  belongs_to :scan
  acts_as_list :scope => :scan_id
  file_column :file
end
