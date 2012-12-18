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
      :foot => {:transformation => :extract_foot, :size => "500" }
    }
  }

  # Case
  belongs_to :a_case, :class_name => 'Case', :foreign_key => 'case_id'
  alias :case :a_case
  scope :unassigned, where(:case_id => nil)

  def extract_result_remarks(image)
    cropped = image.crop(::Magick::NorthWestGravity, 0, 600, image.rows, image.columns * 0.45, true)
    bordered = cropped.border(20, 20, '#AEBCDF')
    bordered.fuzz = 0.15
    trimmed = bordered.trim
    despeckled = trimmed.despeckle
    despeckled.fuzz = 1500
    whited = despeckled.opaque('#EAEAF6', 'white')
    return whited
  end

  def extract_address(image)
    image.crop(::Magick::NorthWestGravity, image.rows, image.columns * 0.5, true)
  end

  def extract_overview(image)
    image.crop(::Magick::NorthWestGravity, 0, 75, 1155, 360, true)
  end

  def extract_head(image)
    image.crop(::Magick::NorthWestGravity, 0, 0, 1172, 586, true)
  end

  def extract_head_big(image)
    image.crop(::Magick::NorthWestGravity, 0, 0, 1172, 586, true)
  end

  def extract_foot(image)
    image.crop(::Magick::NorthWestGravity, 0, 1137, 1172, 469, true)
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
