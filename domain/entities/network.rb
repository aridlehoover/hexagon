require_relative '../../lib/entity'
require_relative '../../lib/validation'

class Network < Entity
  include Validation

  validates :name
  validates :type, list: [:mixed, :virtual, :wired, :wireless]

  attr_accessor :name, :type
end
