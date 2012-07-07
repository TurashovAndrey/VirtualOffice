class Project < ActiveRecord::Base
  belongs_to :company
  belongs_to :user

  has_many :tasks
  has_many :stages
  has_many :comments
end
