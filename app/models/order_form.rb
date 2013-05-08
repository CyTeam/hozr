# encoding: utf-8

require 'rails_file_column'

class OrderForm < ActiveRecord::Base
  include I18nHelpers

  def to_s
    t_model(self.class)
  end

  default_scope order('created_at DESC')

  # Case
  # ====
  belongs_to :case, :autosave => true
  def a_case
    self.case
  end
  scope :unassigned, where(:case_id => nil)

  delegate :doctor_id, :doctor_id=, :examination_date, :examination_date=, :to => :a_case, :allow_nil => true

  # Image
  # =====
  file_column :file, :magick => {
    :versions => {
      :address => {:transformation => :extract_address, :size => "560"},
      :result_remarks => {:transformation => :extract_result_remarks, :size => "620"},
      :overview => {:transformation => :extract_overview },
      :head => {:transformation => :extract_head, :size => "500" },
      :head_big => {:transformation => :extract_head_big, :size => "750" },
      :foot => {:transformation => :extract_foot, :size => "500" },
      :barcode => {:transformation => :extract_barcode, :size => "500" },
      :doctor => {:transformation => :extract_doctor, :size => "500" },
      :mail => { :attributes => { :quality => 30 }, :size => "1000" }
    }
  },
  :root_path => Rails.root.join('system')
  validates :file, :presence => true

  WIDTH = 1200
  def prepare(image)
    image.change_geometry!("#{WIDTH}") {|cols, rows, img|
      img.resize!(cols, rows)
    }
  end

  def extract_result_remarks(image)
    prepare(image)
    image.crop(::Magick::NorthWestGravity, 0, 605, WIDTH, 860, true)
  end

  def extract_barcode(image)
    image.crop(::Magick::NorthWestGravity, image.columns * 0.6, image.rows * 0.22, image.columns * 0.4, image.rows * 0.08, true)
  end

  def extract_address(image)
    image.crop(::Magick::NorthWestGravity, image.rows, image.columns * 0.5, true)
  end

  def extract_overview(image)
    prepare(image)
  end

  def extract_head(image)
    prepare(image)
    image.crop(::Magick::NorthWestGravity, 0, 180, WIDTH, 450, true)
  end

  def extract_head_big(image)
    prepare(image)
    image.crop(::Magick::NorthWestGravity, 0, 180, WIDTH, 450, true)
  end

  def extract_foot(image)
    image.crop(::Magick::NorthWestGravity, 0, 1137, 1172, 469, true)
  end

  def extract_doctor(image)
    prepare(image)
    image.crop(::Magick::NorthWestGravity, 0, 1460, WIDTH, image.rows - 1460, true)
  end

  def mail_file
    img = Magick::Image::read(file('overview')).first
    t = Tempfile.new ['', '.jpg']
    img.write(t) {self.quality = 50}

    t
  end

  # Scanning
  # ========
  SCANNER_SPOOL_PATH = Rails.root.join('tmp')

  def self.post_scanning_processing
    Dir.glob(SCANNER_SPOOL_PATH.join('*.pnm')).sort.each do |scan_name|
      jpg_name = scan_name.gsub(/\.pnm$/, '.jpg')
      system 'convert', scan_name, jpg_name

      text = IO.popen(['gocr', scan_name]).gets(nil)
      code = nil
      if text.match(/<barcode type="128" chars="8" code="([0-9]*)"/)
        code = $1
      end

      self.create(
        :file => File.new(jpg_name),
        :code => code
      )

      File.delete(scan_name, jpg_name)
    end
  end

  def self.import_order_forms(order_form_dir)
    order_form_files = Dir.glob("#{order_form_dir}/*.jpg").sort

    for order_form_file in order_form_files
      a_case = Case.new(order_form_file)
      a_case.save
    end
  end
end
