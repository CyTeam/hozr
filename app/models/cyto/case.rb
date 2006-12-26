class Cyto::Case < ActiveRecord::Base
  belongs_to :examination_method
  belongs_to :classification

  has_and_belongs_to_many :finding_classes
end
