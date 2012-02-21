class Attachment < ActiveRecord::Base
  has_attached_file :attach
  belongs_to :company
  belongs_to :user
end
