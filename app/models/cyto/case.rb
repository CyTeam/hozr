class Cyto::Case < ActiveRecord::Base
  belongs_to :examination_method
  belongs_to :classification

  has_and_belongs_to_many :finding_classes

  def examination_date=(value)
    day, month, year = value.split('.')
    month ||= Date.today.month
    year ||= Date.today.year
  
    write_attribute(:examination_date, "#{year}-#{month}-#{day}")
  end
end
