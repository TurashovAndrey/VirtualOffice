# encoding: utf-8
class User < ActiveRecord::Base
  acts_as_authentic do |user|
    user.require_password_confirmation = false
  end

  attr_accessor :company_name

  has_attached_file :avatar

  extend ActiveHash::Associations::ActiveRecordExtensions
  belongs_to_active_hash :role

  belongs_to :company
  has_many :events

  has_many :attachments

  after_create :create_company_for_manager

  validates_presence_of :email
  validates_presence_of :company_name, :if => Proc.new { |user| user.role == Role::MANAGER }

  default_value_for :password, 'admin'

  attr_accessor :new_password, :new_password_confirmation

  def role_symbols
    [self.role.name.to_sym]
  end

  def active?
    active
  end

  def activate!
    active = true
    save
  end

  def deactivate!
    self.active = false
    save
  end

  def send_activation_instructions!
    reset_perishable_token!
    UserMailer.activation_instructions(self).deliver
  end

  def deliver_activation_instructions!
    reset_perishable_token!
    Notifier.deliver_activation_instructions(self)
  end

  def deliver_activation_confirmation!
    reset_perishable_token!
    Notifier.deliver_activation_confirmation(self)
  end

  protected

  def create_company_for_manager
    if self.role == Role::MANAGER
      self.company = Company.new(:url_base => self.company_name)
      self.save
    end
  end

  private
    def save_password
      self.password = @new_password
    end

end
