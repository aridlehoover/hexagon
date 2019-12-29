require_relative '../../lib/entity'
require_relative '../../lib/validations/validations'

class User < Entity
  include Validations

  validates :name
  validates :email, regex: /\S+@\S+\.\S+/

  attr_accessor :name, :email

  def can?(action, context = nil)
    # authorize user to perform action within the context
  end
end
