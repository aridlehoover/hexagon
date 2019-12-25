require_relative '../../lib/entity'
require_relative '../../lib/validations'

class User < Entity
  include Validations

  validates :name
  validates :email, /\S+@\S+\.\S+/

  attr_accessor :id, :name, :email

  def can?(action, context = nil)
    # authorize user to perform action within the context
  end
end
