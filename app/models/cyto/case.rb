include Cyto

class Cyto::Case < ActiveRecord::Base
  belongs_to :examination_method, :class_name => 'Cyto::ExaminationMethod'
  belongs_to :classification, :class_name => 'Cyto::Classification'
  belongs_to :patient
  belongs_to :doctor
  belongs_to :screener, :class_name => 'Employee', :foreign_key => :screener_id
  belongs_to :insurance
  belongs_to :p16_preparee, :class_name => 'Employee', :foreign_key => :p16_prepared_by
  
  has_and_belongs_to_many :finding_classes
  has_one :order_form, :class_name => 'Cyto::OrderForm'
  
  def bill
    Praxistar::Bill.find(:first, :conditions => ['Leistungsblatt_ID = ?', praxistar_leistungsblatt_id], :order => 'ID_Rechnung DESC')
  end
  
  def active_bill
    Praxistar::Bill.find(:first, :conditions => ['Leistungsblatt_ID = ? AND tf_Storno = 0', praxistar_leistungsblatt_id], :order => 'ID_Rechnung DESC')
  end
  
  def control_findings
    finding_classes.select { |finding| finding.belongs_to_group?('Kontrolle') }
  end
  
  def quality_findings
    finding_classes.select { |finding| finding.belongs_to_group?('Zustand') }
  end
  
  def findings
    finding_classes.select { |finding| !(finding.belongs_to_group?('Zustand') || finding.belongs_to_group?('Kontrolle'))}
  end
  
  def exactly_one_of_group(group_name)
    ( finding_classes.collect { |f| f.id } & Cyto::FindingGroup.find_by_name(group_name).finding_classes.collect { |f| f.id } ).size == 1
  end

  def at_least_one_of_group(group_name)
    ( finding_classes.collect { |f| f.id } & Cyto::FindingGroup.find_by_name(group_name).finding_classes.collect { |f| f.id } ).size >= 1
  end
  
  def validate_findings
    exactly_one_of_group('Zustand') && at_least_one_of_group('Kontrolle')
  end
  
  def validate_first_entry
    valid = true
    if examination_date.nil?
      errors.add('examination_date', 'Abstrichdatum muss gesetzt sein')
      valid = false
    end
    
    if patient_id.nil?
      errors.add('patient_id', 'Patient muss gesetzt sein')
      valid = false
    end
    
    if doctor_id.nil?
      errors.add('doctor_id', 'Arzt muss gesetzt sein')
      valid = false
    end
    
    if patient_id.nil?
      errors.add('patient_id', 'Patient muss gesetzt sein')
      valid = false
    end
    
    if praxistar_eingangsnr.nil?
      errors.add('praxistar_eingangsnr', 'Eingangsnr muss gesetzt sein')
      valid = false
    end
    
    return valid
  end
  
  def validate_second_entry
  end
  
  def validate
    valid = true
    if ready_for_second_entry
      valid &&= validate_first_entry
    end
  
    return valid
  end
  
  def ready_for_first_entry
    entry_date.nil? && !assigned_at.nil?
  end
  
  def ready_for_second_entry
    !entry_date.nil? && screened_at.nil? && !needs_p16?
  end
  
  def ready_for_p16
    screened_at.nil? && needs_p16
  end
  
  def ready_for_result_report_printing
    !entry_date.nil? && !screened_at.nil? && result_report_printed_at.nil?
  end
  
  
  def initialize(params = {})
    case params.class.name
    when 'String'
      initialize_from_order_form_file_name(params)
    when 'File'
      initialize_from_order_form_file(params)
    when 'Cyto::OrderForm'
      initialize_from_order_form(params)
    else
      super(params)
    end
  end
  
  def initialize_from_order_form_file_name(order_form_file_name)
    initialize_from_order_form_file(File.new(order_form_file_name))
  end
  
  def initialize_from_order_form_file(order_form_file)
    initialize_from_order_form(Cyto::OrderForm.new(:file => order_form_file))
  end
  
  def initialize_from_order_form(order_form)
    initialize(:order_form => order_form)
  end
  
  private
  def self.parse_eingangsnr(value)
    Cyto::CaseNr.new(value).to_s
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

  def self.praxistar_create_all_leistungsblatt(days_since_print = 7)
    export = Praxistar::Exports.new(:started_at => Time.now, :model => self.name)
    
    records = self.find(:all, :conditions => [ "praxistar_leistungsblatt_id IS NULL AND (result_report_printed_at IS NOT NULL AND result_report_printed_at < now() - INTERVAL ? DAY ) AND classification_id IS NOT NULL", days_since_print ])
  
    export.record_count = records.size
    export.error_ids = ''
    export.save
    
    for h in records
      begin
        h.praxistar_create_leistungsblatt
      
        export.create_count += 1
        export.save
      rescue Exception => ex
#        export.error_ids += "#{h.id}, "
        export.error_count += 1
        export.save
        
#        print "Error #{self.name}(#{h.id}): #{ex.message}\n"
	print "Error creating bill for case #{h.praxistar_eingangsnr}: #{h.patient.name}, #{h.patient.birth_date}\n\n"
        logger.info "Error #{self.name}(#{h.id}): #{ex.message}\n"
        logger.info ex.backtrace.join("\n\t")
        logger.info "\n"
      end
    end
  
    export.finished_at = Time.now
    export.save
  
    logger.info(export.attributes.to_yaml)
    return export
  end
end
