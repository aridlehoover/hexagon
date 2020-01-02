require_relative '../repositories/user_repository'

class CreateUser
  attr_reader :user, :actor, :context, :adapters

  def initialize(user:, actor:, context: nil, adapters: [])
    @user = user
    @actor = actor
    @context = context
    @adapters = Array(adapters)
  end

  def perform
    return adapters.each(&:unauthorized) unless actor.can?(:create_user, context)
    return adapters.each(&:invalid) if !user.valid?

    created_user = UserRepository.new.create(user)
    return adapters.each(&:failed) if created_user.id.nil?

    adapters.each(&:succeeded)
  end
end
