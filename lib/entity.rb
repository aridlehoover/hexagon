class Entity
  attr_accessor :id, :created_at, :updated_at

  def initialize(attributes = {})
    attributes.each do |field, value|
      method_name = "#{field.to_s}=".to_sym
      send(method_name, value) if self.methods.include?(method_name)
    end
  end

  def attributes
    attrs = Hash.new
    instance_variables.each do |variable|
      key = variable[1..-1].to_sym
      attrs[key] = instance_variable_get(variable)
    end
    attrs
  end
end
