class Task < ActiveRecord::Base
  validates_presence_of :title
  belongs_to :user, :class_name => "User"
  belongs_to :second_user, :class_name => "User"
  belongs_to :company
  belongs_to :stage
  belongs_to :project

  has_many :comments
  has_many :task_attachments

  has_many :permissions
end
