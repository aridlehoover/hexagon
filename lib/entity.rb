class Entity
  attr_accessor :id, :created_at, :updated_at

  def self.attr_accessor(*args)
    add_accessible_attributes(*args)
    super
  end

  def self.add_accessible_attributes(*args)
    accessible_attributes.concat(args)
  end

  def self.accessible_attributes
    @accessible_attributes ||= []
  end

  def initialize(attributes = {})
    attributes.each do |field, value|
      method_name = "#{field}=".to_sym
      send(method_name, value) if self.methods.include?(method_name)
    end
  end

  def attributes
    self.class.accessible_attributes.each_with_object({}) do |variable, attrs|
      attrs[variable.to_sym] = public_send(variable)
    end
  end
end
