require_relative './validators/presence_validator'
require_relative './validators/list_validator'
require_relative './validators/regex_validator'

module Validation
  def self.included(base)
    base.instance_variable_set(:@validations, Hash.new)
    base.extend(ClassMethods)
  end

  module ClassMethods
    def validates(field, validations = { presence: true })
      self.instance_variable_get(:@validations)[field] = validations
    end
  end

  attr_reader :errors

  def valid?
    @errors = Array.new

    validators.each do |validator|
      errors << validator.error unless validator.valid?
    end

    @errors.count == 0
  end

  private

  def validators
    validators = Array.new

    self.class.instance_variable_get(:@validations).each do |field, validations|
      value = send(field)

      validations.each do |validator, validation|
        validators << Industrialist.build(:validator, validator, field, value, validation)
      end
    end

    validators
  end
end
