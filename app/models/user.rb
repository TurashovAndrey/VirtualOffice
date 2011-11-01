class User < ActiveRecord::Base
  acts_as_authentic do |user|
    user.require_password_confirmation = false
  end
end
