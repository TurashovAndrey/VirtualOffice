# encoding: utf-8
class User < ActiveRecord::Base
  acts_as_authentic do |user|
    user.require_password_confirmation = false
  end

  attr_accessor :company_name

  has_attached_file :avatar
  # attr_accessible :avatar

  extend ActiveHash::Associations::ActiveRecordExtensions
  belongs_to_active_hash :role

  belongs_to :company
  has_many :events

  after_create :create_company_for_manager

  validates_presence_of :email
  validates_presence_of :company_name, :if => Proc.new { |user| user.role == Role::MANAGER }

  default_value_for :password, 'admin'

  def role_symbols
    [self.role.name.to_sym]
  end

  protected

  def create_company_for_manager
    if self.role == Role::MANAGER
      self.company = Company.new(:url_base => self.company_name)
      self.save
    end
  end

end
