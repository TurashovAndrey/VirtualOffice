class AddProjectToTaskAttachment < ActiveRecord::Migration
  def change
    add_column :task_attachments, :project_id, :integer
  end
end
