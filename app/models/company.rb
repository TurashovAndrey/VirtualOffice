class Company < ActiveRecord::Base

  has_many :users
  has_many :tasks
  has_many :attachments
  has_many :projects
  has_many :folders
  has_many :calendars
  has_many :themes

  has_many :permissions

  has_attached_file :logo

  validates_format_of :name, :with => /^[a-zA-Z1-9]+$/
  validates_format_of :url_base, :with => /^[a-zA-Z1-9]+$/
  validates_presence_of :url_base
  validates_uniqueness_of :name, :url_base

  default_value_for :name do |company|
    company.url_base
  end

  def to_s
    self.name
  end

end
