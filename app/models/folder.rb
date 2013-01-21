class Folder < ActiveRecord::Base
  include FoldersHelper
  belongs_to :user
  belongs_to :company

  has_many :attachments, dependent: :destroy
  attr_accessible :folder_name
end
