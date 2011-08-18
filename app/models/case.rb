class Case < ActiveRecord::Base
  belongs_to :examination_method
  belongs_to :classification
  belongs_to :patient
  belongs_to :doctor
  belongs_to :first_entry_by, :class_name => 'Employee', :foreign_key => :first_entry_by
  belongs_to :screener, :class_name => 'Employee', :foreign_key => :screener_id
  belongs_to :screened_by, :class_name => 'Employee', :foreign_key => :screener_id
  belongs_to :review_by, :class_name => 'Employee', :foreign_key => :review_by
  belongs_to :insurance
  belongs_to :hpv_p16_prepared_by, :class_name => 'Employee', :foreign_key => :hpv_p16_prepared_by
  
  has_and_belongs_to_many :finding_classes
  has_and_belongs_to_many :mailings
  
  has_one :order_form
  
  # Scopes
  scope :finished, where("screened_at IS NOT NULL AND needs_review = ?", false)
  scope :unfinished_p16, where("screened_at IS NULL AND needs_p16 = ?", true)
  scope :undelivered, where("email_sent_at IS NULL")
  scope :by_classification_group, lambda {|group|
    includes('classification').where('classifications.classification_group_id' => group.id)
  }
  scope :unassigned, where("assigned_at IS NULL")
  scope :first_entry_done, where("entry_date IS NOT NULL and screened_at IS NULL")
  scope :for_second_entry, first_entry_done.where("needs_p16 = ? AND needs_hpv = ?", false, false)
  scope :for_hpv, first_entry_done.where("needs_hpv = ?", true)
  scope :for_p16, first_entry_done.where("needs_p16 = ?", true)
  scope :for_hpv_or_p16, first_entry_done.where("(needs_p16 = ? OR needs_hpv)", true)
  scope :for_print, finished.where("result_report_printed_at IS NULL")
  scope :for_email, finished.where("email_sent_at IS NULL")

  def to_s
    "#{patient.to_s}: PAP Abstrich #{praxistar_eingangsnr}"
  end

  has_one :bill, :class_name => "Praxistar::Bill", :foreign_key => 'Leistungsblatt_ID', :primary_key => 'praxistar_leistungsblatt_id', :order => 'ID_Rechnung DESC'
  has_one :active_bill, :class_name => "Praxistar::Bill", :foreign_key => 'Leistungsblatt_ID', :primary_key => 'praxistar_leistungsblatt_id', :order => 'ID_Rechnung DESC', :conditions => "tf_Storno = 0"

  def control_findings
    finding_classes.by_finding_group('Kontrolle')
  end
  
  def quality_findings
    finding_classes.by_finding_group('Zustand')
  end
  
  def findings
    finding_classes.by_finding_group(nil)
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
  
  def ready_for_praxistar_create_leistungsblatt
    !screened_at.nil? && praxistar_leistungsblatt_id.nil?
  end
  
  
  def initialize(params = {})
    case params.class.name
    when 'String'
      initialize_from_order_form_file_name(params)
    when 'File'
      initialize_from_order_form_file(params)
    when 'OrderForm'
      initialize_from_order_form(params)
    else
      super(params)
    end
  end
  
  def initialize_from_order_form_file_name(order_form_file_name)
    initialize_from_order_form_file(File.new(order_form_file_name))
  end
  
  def initialize_from_order_form_file(order_form_file)
    initialize_from_order_form(OrderForm.new(:file => order_form_file))
  end
  
  def initialize_from_order_form(order_form)
    initialize(:order_form => order_form)
  end
  
  private
  def self.parse_eingangsnr(value)
    CaseNr.new(value).to_s
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
    blatt.save!
    self.praxistar_leistungsblatt_id = blatt.id
    save!
  end

  belongs_to :praxistar_leistungsblatt, :class_name => 'Praxistar::LeistungenBlatt'


  BILL_DELAY_DAYS = 6.5
  scope :to_create_leistungsblatt, where("praxistar_leistungsblatt_id IS NULL AND (IFNULL(email_sent_at, result_report_printed_at) < now() - INTERVAL ? HOUR ) AND classification_id IS NOT NULL", BILL_DELAY_DAYS * 24)

  def self.praxistar_create_all_leistungsblatt
    export = Praxistar::Exports.new(:started_at => Time.now, :model => self.name)
    
    records = self.to_create_leistungsblatt.all
  
    error_cases = []
    export.record_count = records.size
    export.error_ids = ''
    export.save
    
    for h in records
      begin
        h.praxistar_create_leistungsblatt
      
        export.create_count += 1
        export.save
      rescue Exception => ex
        error_cases << h
        export.error_count += 1
        export.save
        
        print "Error #{self.name}(#{h.id}): #{ex.message}\n"
	print "Error creating bill for case #{h.praxistar_eingangsnr}: #{h.patient.name}, #{h.patient.birth_date}\n\n"
        logger.info "Error #{self.name}(#{h.id}): #{ex.message}\n"
        logger.info ex.backtrace.join("\n\t")
        logger.info "\n"
      end
    end
  
    export.finished_at = Time.now
    export.error_ids = error_cases.collect{|c| c.id}.join(', ')
    export.save
  
    logger.info(export.attributes.to_yaml)
    return export
  end

  # PDF
  def to_pdf(page_size = 'A5')
    case page_size
    when 'A5':
      prawn_options = { :page_size => page_size, :top_margin => 60, :left_margin => 35, :right_margin => 35, :bottom_margin => 23 }
    when 'A4':
      prawn_options = { :page_size => page_size, :top_margin => 90, :left_margin => 40, :right_margin => 40, :bottom_margin => 40 }
    end

    pdf = ResultReport.new(prawn_options)
    
    return pdf.to_pdf(self)
  end
  
  def print(page_size, printer)
    # Workaround TransientJob not yet accepting options
    file = Tempfile.new('')
    file.puts(to_pdf(page_size))
    file.close

    begin
      paper_copy = Cups::PrintJob.new(file.path, printer)
    rescue
      paper_copy = Cups::PrintJob.new(file.path, printer)
    end
    paper_copy.print
  end

  def pdf_path
    Rails.root.join('public', 'result_reports', "result_report-#{id}.pdf")
  end

  def pdf_name
    "#{patient.to_s}: PAP Abstrich #{praxistar_eingangsnr}.pdf"
  end

  # Email
  def deliver_report_by_email
    CaseMailer.deliver_report(self)
  end
end
