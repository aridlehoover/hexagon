require_relative './validator'

class RegexValidator < Validator
  corresponds_to :regex

  attr_reader :field, :value, :regex

  def initialize(field, value, regex)
    @field = field
    @value = value
    @regex = regex
  end

  def valid?
    return false if value.nil?
    !!(value =~ regex)
  end

  def error
    "#{field} does not match #{regex.inspect}" unless valid?
  end
end