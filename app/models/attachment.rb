class Attachment < ActiveRecord::Base
  has_attached_file :attach
  belongs_to :company
  belongs_to :user
  belongs_to :folder

  attr_accessible :attach_file_name, :attach_content_type, :attach_file_size, :attach_updated_at, :folder_id
end
