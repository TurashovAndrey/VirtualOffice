class Comment < ActiveRecord::Base
  belongs_to :user
  belongs_to :company
  belongs_to :task
  belongs_to :stage
  belongs_to :project
  belongs_to :discussion

  has_many :task_attachments
end
