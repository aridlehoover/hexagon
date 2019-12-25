require_relative '../repositories/user_repository'

class CreateUser
  attr_reader :actor, :user, :adapters

  def initialize(actor, user, adapters = [])
    @actor = actor
    @user = user
    @adapters = Array(adapters)
  end

  def perform
    return adapters.each(&:unauthorized) if !actor.can?(:create_user)
    return adapters.each(&:invalid) if !user.valid?

    created_user = UserRepository.new.create(user)
    return adapters.each(&:failed) if created_user.id.nil?

    adapters.each(&:succeeded)
  end
end
