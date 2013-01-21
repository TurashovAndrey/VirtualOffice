# encoding: utf-8
class User < ActiveRecord::Base
  acts_as_authentic do |user|
    user.require_password_confirmation = false
  end

  attr_accessor :company_name
  attr_reader :name

  has_attached_file :avatar

  belongs_to_active_hash :role

  belongs_to :company
  has_many   :events
  has_many   :streams
  has_many   :attachments
  has_many   :comments
  has_many   :projects
  has_many   :folders
  has_many   :permissions
  has_many   :conferences

  belongs_to :group

  after_create :create_company_for_manager

  validates_presence_of :email
  validates_presence_of :company_name, :if => Proc.new { |user| user.role == Role::MANAGER }

  default_value_for :password, 'admin'

  attr_accessor :new_password, :new_password_confirmation

  def name
    if (self.first_name.empty?) && (self.last_name.empty?)
      self.email
    else
      if (self.first_name.empty?)
        self.last_name
      else
        if (self.last_name.empty?)
          self.first_name
        else
          self.first_name+" "+self.last_name
        end
      end
    end
  end

  def active?
    active
  end

  def activate!
    active = true
    save
  end

  protected

  def create_company_for_manager
    if self.role == Role::MANAGER
      self.company = Company.new(:url_base => self.company_name)

      self.company.save
      self.save
    end
  end
end
