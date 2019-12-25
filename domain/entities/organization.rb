require_relative '../../lib/entity'
require_relative '../../lib/validations'

class Organization < Entity
  include Validations

  validates :name

  attr_accessor :id, :name
end
