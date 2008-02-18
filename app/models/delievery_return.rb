class DelieveryReturn < ActiveRecord::Base
  belongs_to :bill, :class_name => 'Praxistar::Bill'
end
