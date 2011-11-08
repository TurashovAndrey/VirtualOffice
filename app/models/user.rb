class User < ActiveRecord::Base
  acts_as_authentic do |user|
    user.require_password_confirmation = false
  end

  extend ActiveHash::Associations::ActiveRecordExtensions
  belongs_to_active_hash :role

  validates_presence_of :email, :company_name

  def role_symbols
    [self.role.name.to_sym]
  end
end
