class Cyto::OrderForm < ActiveRecord::Base
  file_column :file, :magick => {
    :versions => {
      :full => {:size => "480"},
#      :address => {:transformation => Proc.new { |image| image.crop(::Magick::NorthWestGravity, image.rows, image.columns * 0.5, true) }, :size => "560"},
#      :remarks => {:transformation => :extract_remarks }
      :remarks => {:size => "410"}
    }
  }

  belongs_to :a_case, :class_name => 'Case', :foreign_key => 'case_id'
end
