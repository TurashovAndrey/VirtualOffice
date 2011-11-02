class Role < ActiveHash::Base
  include ActiveHash::Enum
  include HumanAttributeValue

  self.data = [
    {:id => 1, :name => 'guest'},
    {:id => 2, :name => 'admin'},
    {:id => 3, :name => 'manager'},
    {:id => 4, :name => 'worker'}
  ]

  enum_accessor :name

  def self.authenticated
    self.all - [self::GUEST]
  end

end