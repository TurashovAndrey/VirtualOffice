class Group < ActiveRecord::Base
  has_many :users
  has_many :permissions

  belongs_to :company
end
