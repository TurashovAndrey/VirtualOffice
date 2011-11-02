module HumanAttributeValue
  def self.included m
    m.send(:include, HumanAttributeName)
  end

  def to_s
    self.human_atrribute_value :name
  end

  def human_name(args = {})
    (args[:count] || 1) > 1 ?
    self.to_s.pluralize :
    self.to_s        
  end

  protected

  def human_atrribute_value(column)
    self.class.human_attribute_name("#{column.to_s.pluralize}.#{self.send(column)}")
  end
  
end