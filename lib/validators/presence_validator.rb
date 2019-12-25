require_relative './validator'

class PresenceValidator < Validator
  corresponds_to :presence

  attr_reader :field, :value, :validation

  def initialize(field, value, validation)
    @field = field
    @value = value
    @validation = validation
  end

  def valid?
    !value.nil?
  end

  def error
    "#{field} missing" unless valid?
  end
end
