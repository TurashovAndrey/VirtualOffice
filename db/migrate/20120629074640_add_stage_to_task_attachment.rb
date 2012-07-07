class AddStageToTaskAttachment < ActiveRecord::Migration
  def change
    add_column :task_attachments, :stage_id, :integer
  end
end
