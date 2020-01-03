require_relative '../../lib/entity'
require_relative '../../lib/validation'

class Network < Entity
  TYPES = [:mixed, :virtual, :wired, :wireless]

  include Validation

  validates :name
  validates :type, list: TYPES

  attr_accessor :name, :type
end
