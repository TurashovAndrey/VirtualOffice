class Company < ActiveRecord::Base

  has_many :users
  has_many :events

  validates_presence_of :url_base
  validates_uniqueness_of :name, :url_base

  default_value_for :name do |company|
    company.url_base
  end

  def to_s
    self.name
  end

end
