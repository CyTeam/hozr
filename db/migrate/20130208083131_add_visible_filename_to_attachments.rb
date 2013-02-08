class AddVisibleFilenameToAttachments < ActiveRecord::Migration
  def change
    add_column :attachments, :visible_filename, :string
  end
end
