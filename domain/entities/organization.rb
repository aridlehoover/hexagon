require_relative '../../lib/entity'
require_relative '../../lib/validation'

class Organization < Entity
  include Validation

  validates :name

  attr_accessor :name
end
