class AddDiscussionToTaskAttachment < ActiveRecord::Migration
  def change
    add_column :task_attachments, :discussion_id, :integer
  end
end
