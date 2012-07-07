class AddCommentToTaskAttachment < ActiveRecord::Migration
  def change
    add_column :task_attachments, :comment_id, :integer
  end
end
