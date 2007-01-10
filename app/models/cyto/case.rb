class Cyto::Case < ActiveRecord::Base
  belongs_to :examination_method
  belongs_to :classification
  belongs_to :patient
  belongs_to :doctor
  belongs_to :screener, :class_name => 'Employee', :foreign_key => :screener_id
  belongs_to :insurance
  
  has_and_belongs_to_many :finding_classes
  has_one :order_form
  
  def ready_for_first_entry
    entry_date.nil?
  end
  
  def ready_for_second_entry
    !entry_date.nil? && screened_at.nil? && !needs_p16
  end
  
  def ready_for_p16
    screened_at.nil? && needs_p16
  end
  
  def ready_for_result_report_printing
    !entry_date.nil? && !screened_at.nil? && result_report_printed_at.nil?
  end
  
  def self.new_order_form(order_form_scan)
    order_form = OrderForm.new
    order_form.file = File.new(order_form_scan)
    order_form.save
    
    a_case = new
    a_case.order_form = order_form
    a_case.save
  end
  
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
  
  def examination_date_before_type_cast
    read_attribute(:examination_date).strftime("%d.%m.%Y") unless read_attribute(:examination_date).nil?
  end
  
  def entry_date=(value)
    if value.is_a?(String)
      day, month, year = value.split('.')
      month ||= Date.today.month
      year ||= Date.today.year
      year = 2000 + year.to_i if year.to_i < 100
      
      write_attribute(:entry_date, "#{year}-#{month}-#{day}")
    else
      write_attribute(:entry_date, value)
    end
  end

  def entry_date_before_type_cast
    read_attribute(:entry_date).strftime("%d.%m.%Y") unless read_attribute(:entry_date).nil?
  end
  
  def praxistar_create_leistungsblatt
    blatt = Praxistar::LeistungenBlatt.new
    blatt.hozr_case = self
    blatt.save
    self.praxistar_leistungsblatt_id = blatt.id
    save
  end

  def self.praxistar_create_all_leistungsblatt
    cases_to_book = self.find(:all, :conditions => "praxistar_leistungsblatt_id is null and classification_id is not null and praxistar_eingangsnr > '06/30000'")
  
    for a_case in cases_to_book
      a_case.praxistar_create_leistungsblatt
    end
  end
end
