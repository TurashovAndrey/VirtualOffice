class Folder < ActiveRecord::Base
  belongs_to :user
  belongs_to :company

  has_many :attachments

  has_many :permissions
end
