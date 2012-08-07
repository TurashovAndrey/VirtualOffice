class Theme < ActiveRecord::Base
  belongs_to :user
  belongs_to :company

  has_many :discussions
  has_many :permissions
end
