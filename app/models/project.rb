class Project < ActiveRecord::Base
  belongs_to :company
  belongs_to :user

  has_many :tasks
  has_many :stages
  has_many :comments
  has_many :permissions
end
