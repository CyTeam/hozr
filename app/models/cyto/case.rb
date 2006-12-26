class Cyto::Case < ActiveRecord::Base
  belongs_to :examination_method
  belongs_to :classification
end
