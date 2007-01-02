class Cyto::Case < ActiveRecord::Base
  belongs_to :examination_method
  belongs_to :classification
  belongs_to :patient
  belongs_to :doctor
  belongs_to :screener, :class_name => 'Employee', :foreign_key => :screener_id
  
  has_and_belongs_to_many :finding_classes

  private
  def self.parse_eingangsnr(value)
    left, right = value.split('/')
    if right.nil?
      year = '06'
      number = sprintf("%05d", left.to_i)
    else
      year = sprintf("%02d", left.to_i)
      number = sprintf("%05d", right.to_i)
    end
    
    return "#{year}/#{number}"
  end
  
  public
  def praxistar_eingangsnr=(value)
    write_attribute(:praxistar_eingangsnr, Case.parse_eingangsnr(value))
  end

  def self.praxistar_eingangsnr_exists?(value)
    return !( find_by_praxistar_eingangsnr(parse_eingangsnr(value)).nil? )
  end
  
  def examination_date=(value)
    if value.is_a?(String)
      day, month, year = value.split('.')
      month ||= Date.today.month
      year ||= Date.today.year
      year = 2000 + year.to_i if year.to_i < 100
      
      write_attribute(:examination_date, "#{year}-#{month}-#{day}")
    else
      write_attribute(:examination_date, value)
    end
  end
end
