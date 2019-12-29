require_relative '../../lib/entity'
require_relative '../../lib/validations/validations'

class Network < Entity
  include Validations

  validates :name
  validates :type, list: [:mixed, :wired, :wireless]

  attr_accessor :name, :type
end
