class Room < ActiveRecord::Base
  has_many :conferences

  attr_accessor :room_name

  def room_name
    room_name
  end

  def room_name=
    room_name = value
  end
end
