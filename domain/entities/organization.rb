require_relative '../../lib/entity'
require_relative '../../lib/validations/validations'

class Organization < Entity
  include Validations

  validates :name

  attr_accessor :name
end
