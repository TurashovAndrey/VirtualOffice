class AddFolderToAttachment < ActiveRecord::Migration
  def change
    add_column :attachments, :folder_id, :integer
  end
end
