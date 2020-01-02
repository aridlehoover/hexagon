require_relative './validator'

class ListValidator < Validator
  corresponds_to :list

  attr_reader :field, :value, :list

  def initialize(field, value, list)
    @field = field
    @value = value
    @list = Array(list)
  end

  def valid?
    list.include?(value)
  end

  def error
    "#{field} not in #{list.inspect}" unless valid?
  end
end