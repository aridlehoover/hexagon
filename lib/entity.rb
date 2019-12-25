class Entity
  def initialize(attributes = {})
    attributes.each do |field, value|
      method_name = "#{field.to_s}=".to_sym
      send(method_name, value) if self.methods.include?(method_name)
    end
  end
end
