class TaskAttachment < ActiveRecord::Base
  has_attached_file :attachment
  belongs_to :user
  belongs_to :company
  belongs_to :task
  belongs_to :comment
end
