class Permission < ActiveRecord::Base
  belongs_to :user
  belongs_to :group
  belongs_to :task
  belongs_to :company
  belongs_to :folder
  belongs_to :calendar
  belongs_to :theme
  belongs_to :project
end
