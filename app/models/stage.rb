class Stage < ActiveRecord::Base
  has_many :tasks
  has_many :comments
  has_many :attachments

  belongs_to :project
end
