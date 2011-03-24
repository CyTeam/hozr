class ClassificationGroup < ActiveRecord::Base
  has_many :classifications, :class_name => 'Classification'
end
