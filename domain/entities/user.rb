require_relative '../../lib/entity'
require_relative '../../lib/validation'
require_relative '../../lib/authorization'

class User < Entity
  include Validation
  include Authorization

  validates :name
  validates :email, regex: /\S+@\S+\.\S+/

  attr_accessor :name, :email
end
