class Calendar < ActiveRecord::Base
  has_many :events
  has_many :permissions
  belongs_to :user
  belongs_to :company

end
