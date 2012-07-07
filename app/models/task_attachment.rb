class TaskAttachment < ActiveRecord::Base
  has_attached_file :attachment
  belongs_to :user
  belongs_to :company
  belongs_to :task
  belongs_to :comment
  belongs_to :stage
  belongs_to :project
  belongs_to :discussion
end
