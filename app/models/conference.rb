class Conference < ActiveRecord::Base
  belongs_to :room
  belongs_to :company
  belongs_to :user
  belongs_to :group
end
