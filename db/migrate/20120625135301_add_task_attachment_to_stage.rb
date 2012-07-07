class AddTaskAttachmentToStage < ActiveRecord::Migration
  def change
    add_column :stages, :task_attachment_id, :integer
  end
end
