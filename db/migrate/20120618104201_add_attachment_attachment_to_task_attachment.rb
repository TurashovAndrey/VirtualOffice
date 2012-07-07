class AddAttachmentAttachmentToTaskAttachment < ActiveRecord::Migration
  def self.up
    add_column :task_attachments, :attachment_file_name, :string
    add_column :task_attachments, :attachment_content_type, :string
    add_column :task_attachments, :attachment_file_size, :integer
    add_column :task_attachments, :attachment_updated_at, :datetime
  end

  def self.down
    remove_column :task_attachments, :attachment_file_name
    remove_column :task_attachments, :attachment_content_type
    remove_column :task_attachments, :attachment_file_size
    remove_column :task_attachments, :attachment_updated_at
  end
end
