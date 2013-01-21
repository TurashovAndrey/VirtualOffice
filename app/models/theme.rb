class Theme < ActiveRecord::Base
  acts_as_commentable

  belongs_to :user
  belongs_to :company

end
