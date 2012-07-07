class AddFolderToPermission < ActiveRecord::Migration
  def change
    add_column :permissions, :folder_id, :integer
  end
end
