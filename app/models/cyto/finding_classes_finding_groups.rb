class Cyto::FindingClassesFindingGroups < ActiveRecord::Base
  belongs_to :finding_classes
  belongs_to :finding_groups
end
