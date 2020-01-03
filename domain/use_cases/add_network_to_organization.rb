require_relative '../repositories/network_repository'

class AddNetworkToOrganization
  attr_reader :network, :actor, :context, :adapters

  def initialize(network:, actor:, context: nil, adapters: [])
    @network = network
    @actor = actor
    @context = context
    @adapters = Array(adapters)
  end

  def perform
    return adapters.each(&:unauthorized) unless actor.can?(:add_network_to_organization, context)

    network.organization_id = context.id
    return adapters.each(&:invalid) unless network.valid?

    updated_network = NetworkRepository.new.update(network)
    return adapters.each(&:failed) unless updated_network.organization_id == context.id

    adapters.each(&:succeeded)
  end
end
