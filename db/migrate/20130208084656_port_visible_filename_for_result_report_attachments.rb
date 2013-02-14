class PortVisibleFilenameForResultReportAttachments < ActiveRecord::Migration
  def up
    Attachment.where(:object_type => 'Case').find_each do |a|
      a.update_column(:visible_filename, a.object.try(:pdf_name))
    end
  end
end
