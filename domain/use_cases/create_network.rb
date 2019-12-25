require_relative '../repositories/network_repository'

class CreateNetwork
  attr_reader :actor, :organization, :network, :adapters

  def initialize(actor, organization, network, adapters = [])
    @actor = actor
    @organization = organization
    @network = network
    @adapters = Array(adapters)
  end

  def perform
    return adapters.each(&:unauthorized) if !actor.can?(:create_network, organization)
    return adapters.each(&:invalid) if !network.valid?

    created_network = NetworkRepository.new.create(network)
    return adapters.each(&:failed) if created_network.id.nil?

    adapters.each(&:succeeded)
  end
end
