require_relative '../repositories/network_repository'

class CreateNetwork
  attr_reader :user, :organization, :network, :adapters

  def initialize(user, organization, network, adapters = [])
    @user = user
    @organization = organization
    @network = network
    @adapters = Array(adapters)
  end

  def perform
    return adapters.each(&:unauthorized) if !user.can?(:create_network, organization)
    return adapters.each(&:invalid) if !network.valid?

    created_network = NetworkRepository.new.create(network)
    return adapters.each(&:failed) if created_network.id.nil?

    adapters.each(&:succeeded)
  end
end
