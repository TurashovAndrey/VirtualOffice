class Discussion < ActiveRecord::Base
  belongs_to :user
  belongs_to :company
  belongs_to :theme

  has_many   :comments
  has_many   :task_attachments
end
