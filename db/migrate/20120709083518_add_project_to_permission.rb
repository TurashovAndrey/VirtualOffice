class AddProjectToPermission < ActiveRecord::Migration
  def change
    add_column :permissions, :project_id, :integer
  end
end
