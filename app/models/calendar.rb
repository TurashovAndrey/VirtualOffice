class Calendar < ActiveRecord::Base
  has_many   :events, dependent: :destroy
  belongs_to :user
  belongs_to :company

  attr_accessible :calendar_name
  validate :calendar_name, presence: true
end
