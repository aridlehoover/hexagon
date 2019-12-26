require_relative '../repositories/network_repository'

class CreateNetwork
  attr_reader :network, :actor, :context, :adapters

  def initialize(network:, actor:, context: nil, adapters: [])
    @network = network
    @actor = actor
    @context = context
    @adapters = Array(adapters)
  end

  def perform
    return adapters.each(&:unauthorized) if !actor.can?(:create_network, context)
    return adapters.each(&:invalid) if !network.valid?

    created_network = NetworkRepository.new.create(network)
    return adapters.each(&:failed) if created_network.id.nil?

    adapters.each(&:succeeded)
  end
end
