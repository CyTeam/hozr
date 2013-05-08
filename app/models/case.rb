# encoding: utf-8

class Case < ActiveRecord::Base
  belongs_to :examination_method

  belongs_to :patient, :autosave => true, :touch => true
  accepts_nested_attributes_for :patient

  belongs_to :doctor
  belongs_to :first_entry_submitter, :class_name => 'Person', :foreign_key => :first_entry_by
  belongs_to :screener, :class_name => 'Person', :foreign_key => :screener_id
  belongs_to :screened_by, :class_name => 'Person', :foreign_key => :screener_id
  belongs_to :reviewer, :class_name => 'Person', :foreign_key => :review_by
  belongs_to :insurance
  belongs_to :hpv_p16_prepared_by, :class_name => 'Person', :foreign_key => :hpv_p16_prepared_by

  has_and_belongs_to_many :finding_classes
  # Mailings
  has_and_belongs_to_many :mailings
  has_many :send_queues, :through => :mailings

  # Fax
  has_many :faxes

  # Classification
  belongs_to :classification
  scope :by_classification_group, lambda {|group|
    includes('classification').where('classifications.classification_group_id' => group.id)
  }
  validates :classification, :presence => true, :on => :review_done
  def classification
    super || Classification.default
  end
  def classification_id
    self[:classification_id] || Classification.default.try(:id)
  end

  # CaseCopyTo
  has_many :case_copy_tos, :dependent => :destroy
  accepts_nested_attributes_for :case_copy_tos

  has_one :order_form, :autosave => true
  def order_form_id
    self.order_form.try(:id)
  end

  def order_form_id=(value)
    self.order_form = OrderForm.find(value)
  end

  # Scopes
  scope :finished, where("screened_at IS NOT NULL AND needs_review = ?", false)
  scope :unfinished_p16, where("screened_at IS NULL AND needs_p16 = ?", true)
  scope :unassigned, where("assigned_at IS NULL")
  scope :first_entry_done, where("first_entry_at IS NOT NULL and screened_at IS NULL")

  scope :for_assignment, where("examination_date IS NULL")
  scope :for_scanning, unassigned.where("cases.id NOT IN (SELECT case_id FROM order_forms WHERE case_id IS NOT NULL)")
  scope :for_first_entry, where("first_entry_at IS NULL and assigned_at IS NOT NULL")
  scope :for_second_entry, first_entry_done.where("needs_p16 = ? AND needs_hpv = ?", false, false)
  scope :for_p16, first_entry_done.where("needs_p16 = ?", true)
  scope :for_hpv, first_entry_done.where("needs_hpv = ?", true)
  scope :for_hpv_p16, first_entry_done.where("needs_p16 = ? OR needs_hpv = ?", true, true)
  scope :for_review, where("needs_review = ?", true)

  scope :undelivered, where("delivered_at IS NULL")
  scope :for_delivery, finished.undelivered.where("doctor_id IS NOT NULL")

  def code
    praxistar_eingangsnr
  end
  def code=(value)
    self.praxistar_eingangsnr = value
  end

  def code_to_s
    "B%s" % [code]
  end

  def to_s
    # TODO: generalize as Case-Code prefix
    "#{patient.to_s}: #{code_to_s}"
  end

  def control_findings
    finding_classes.control
  end

  def quality_findings
    finding_classes.quality
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

    if praxistar_eingangsnr.nil?
      errors.add('praxistar_eingangsnr', 'Eingangsnr muss gesetzt sein')
      valid = false
    end

    return valid
  end

  def validate_second_entry
  end

  validates :patient, :presence => true, :on => :sign
  validates :doctor, :presence => true, :on => :sign

  validates :patient, :presence => true, :on => :review_done
  validates :doctor, :presence => true, :on => :review_done

  def ready_for_first_entry
    first_entry_at.nil? && !assigned_at.nil?
  end

  def ready_for_second_entry
    !first_entry_at.nil? && screened_at.nil? && !needs_p16?
  end

  def ready_for_p16
    screened_at.nil? && needs_p16
  end

  def next_case(scope_name)
    scope = nil
    if scope_name
      scope = self.class.send(scope_name)
    else
      scope = self.class
    end
    scope.where("id > ?", id).first
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

  # Actions
  def sign(screener)
    self.needs_review = true # TODO: use setting
    self.screener = screener
    self.screened_at = Time.now
  end

  def review_done(reviewer)
    self.needs_review = false
    self.reviewer = reviewer
    self.review_at = Time.now
  end

  # PDF
  def to_pdf(page_size = 'A5', to = nil)
    case page_size
    when 'A5'
      prawn_options = { :page_size => page_size }
    when 'A4'
      prawn_options = { :page_size => page_size }
    end

    pdf = ResultReport.new(prawn_options)

    return pdf.to_pdf(self, to)
  end

  def print(page_size, printer, to = nil)
    file = Tempfile.new('')
    file.binmode
    file.puts(to_pdf(page_size, to))
    file.close

    printer.print_file(file.path)
  end

  def pdf_name(name = '')
    name = name.strip
    name = ' ' + name if name.present?
    I18n.transliterate(to_s + name) + '.pdf'
  end

  # Attachments
  # ===========
  has_many :attachments, :as => :object
  accepts_nested_attributes_for :attachments, :reject_if => proc { |attributes| attributes['file'].blank? }

  def persist_pdf
    temp = Tempfile.open('hozr')
    temp.binmode
    temp.write to_pdf
    temp.close
    title = "Bericht %i" % [attachments.count + 1]

    attachments.create(
      :file => temp,
      :title => title,
      :visible_filename => pdf_name(title)
    )
  end

  # Sphinx Search
  # =============
  define_index do
    indexes :praxistar_eingangsnr
    indexes :remarks

    has :entry_date
    has :assigned_at
  end

  # Slidepath
  def location_index
    Slidepath::LocationIndex.where("fileName LIKE ?", "#{id}_%")
  end

  # CyDoc
  # =====
  has_one :treatment, :foreign_key => :imported_id
  scope :for_billing, lambda { finished.includes(:treatment).where('treatments.id IS NULL')}
  def for_billing?
    Case.for_billing.exists?(self.id)
  end
end
