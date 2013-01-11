# encoding: utf-8

require 'rails_file_column'

class OrderForm < ActiveRecord::Base
  include I18nHelpers

  def to_s
    t_model(self.class)
  end

  default_scope order('created_at DESC')

  file_column :file, :magick => {
    :versions => {
      :address => {:transformation => :extract_address, :size => "560"},
      :result_remarks => {:transformation => :extract_result_remarks, :size => "620"},
      :overview => {:transformation => :extract_overview },
      :head => {:transformation => :extract_head, :size => "500" },
      :head_big => {:transformation => :extract_head_big, :size => "750" },
      :foot => {:transformation => :extract_foot, :size => "500" },
      :assignment => {:transformation => :extract_assignment, :size => "500" }
    }
  },
  :root_path => Rails.root.join('system')

  # Case
  belongs_to :a_case, :class_name => 'Case', :foreign_key => 'case_id'
  alias :case :a_case
  scope :unassigned, where(:case_id => nil)

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

  def extract_assignment(image)
    prepare(image)
    image.crop(::Magick::NorthWestGravity, 0, 1460, WIDTH, image.rows - 1460, true)
  end

  # Scanning
  # ========
  SCANNER_SPOOL_PATH = Rails.root.join('tmp')

  def self.post_scanning_processing
    Dir.glob(SCANNER_SPOOL_PATH.join('*.pnm')).sort.each do |scan_name|
      png_name = scan_name.gsub(/\.pnm$/, '.png')
      system 'convert', scan_name, png_name

      text = IO.popen(['gocr', png_name]).gets(nil)
      code = nil
      if text.match(/<barcode type="128" chars="8" code="([0-9]*)"/)
        code = $1
      end

      self.create(
        :file => File.new(png_name),
        :code => code
      )
    end
  end

  def self.import_order_forms(order_form_dir)
    order_form_files = Dir.glob("#{order_form_dir}/*.jpg").sort

    p "Anzahl: #{order_form_files.size}"

    for order_form_file in order_form_files
      a_case = Case.new(order_form_file)
      a_case.save
    end
  end
end
