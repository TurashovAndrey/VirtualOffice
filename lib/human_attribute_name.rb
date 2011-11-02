module HumanAttributeName
  def self.included(m)
      
    m.extend ClassMethods
  end

  module ClassMethods
    def human_attribute_name(attribute_key_name, options = {})
      defaults = [:"#{self.name.underscore}.#{attribute_key_name}"]
      defaults << options[:default] if options[:default]
      defaults.flatten!
      defaults << attribute_key_name.to_s.humanize
      options[:count] ||= 1
      I18n.translate(defaults.shift, options.merge(:default => defaults, :scope => [:activerecord, :attributes]))
    end
  end
end