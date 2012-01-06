class Task < ActiveRecord::Base
  validates_presence_of :title
  belongs_to :user, :class_name => "User"
  belongs_to :second_user, :class_name => "User"
  belongs_to :company
end
