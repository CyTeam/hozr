class Cyto::Case < ActiveRecord::Base
  belongs_to :examination_method
  belongs_to :classification

  has_and_belongs_to_many :finding_classes

  def praxistar_eingangsnr=(value)
    left, right = value.split('/')
    if right.nil?
      year = '06'
      number = sprintf("%05d", left)
    else
      year = sprintf("%02d", left)
      number = sprintf("%05d", right)
    end
  
    write_attribute(:praxistar_eingangsnr, "#{year}/#{number}")
  end

  def examination_date=(value)
    day, month, year = value.split('.')
    month ||= Date.today.month
    year ||= Date.today.year
    year = 2000 + year if year < 100
    
    write_attribute(:examination_date, "#{year}-#{month}-#{day}")
  end
end
