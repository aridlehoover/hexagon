module Validations
  def self.included(base)
    base.instance_variable_set(:@rules, Hash.new)
    base.extend(ClassMethods)
  end

  module ClassMethods
    def validates(field, validation = :present)
      self.instance_variable_get(:@rules)[field] = validation
    end
  end

  attr_reader :errors

  def valid?
    @errors = Array.new

    self.class.instance_variable_get(:@rules).each do |field, rule|
      value = send(field)

      case true
      when rule == :present
        if value.nil?
          @errors << "#{field.to_s} missing"
        end
      when rule.is_a?(Array)
        if !rule.include?(value)
          @errors << "#{field.to_s} not in #{rule.inspect}"
        end
      when rule.is_a?(Regexp)
        if value.nil? || !(value =~ rule)
          @errors << "#{field.to_s} does not match #{rule.inspect}"
        end
      end
    end

    @errors.count == 0
  end
end
