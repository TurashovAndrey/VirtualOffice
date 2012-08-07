class Group < ActiveRecord::Base
  has_many :users
  has_many :permissions
  has_many :conferences

  belongs_to :company
end
