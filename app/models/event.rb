class Event < ActiveRecord::Base
  has_event_calendar
  belongs_to :user
  belongs_to :company

  default_value_for :start_at, Date.today
  default_value_for :end_at, Date.today
  default_value_for :color, "#0000FF"
  default_value_for :description, ""
end
