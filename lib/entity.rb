class Entity
  attr_accessor :id, :created_at, :updated_at

  def initialize(attributes = {})
    attributes.each do |field, value|
      method_name = "#{field.to_s}=".to_sym
      send(method_name, value) if self.methods.include?(method_name)
    end
  end

  def attributes
    attrs = {}
    instance_variables.each { |variable| attrs.merge(variable: instance_variable_get(variable)) }
    attrs
  end
end
