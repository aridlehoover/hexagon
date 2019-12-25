require_relative '../../lib/entity'
require_relative '../../lib/validations'

class Network < Entity
  include Validations

  validates :name
  validates :type, list: [:mixed, :wired, :wireless]

  attr_accessor :id, :name, :type
end
