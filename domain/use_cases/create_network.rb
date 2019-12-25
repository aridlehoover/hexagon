require_relative '../entities/user'
require_relative '../entities/organization'
require_relative '../entities/network'
require_relative '../repositories/user_repository'
require_relative '../repositories/organization_repository'
require_relative '../repositories/network_repository'

class CreateNetwork
  attr_reader :user_id, :organization_id, :request_model, :adapters

  def initialize(user_id, organization_id, request_model, adapters = [])
    @user_id = user_id
    @organization_id = organization_id
    @request_model = request_model
    @adapters = Array(adapters)
  end

  def perform
    return adapters.each(&:invalid_argument) if user_id.nil? || organization_id.nil?

    user = UserRepository.new.find(user_id)
    organization = OrganizationRepository.new.find(organization_id)
    return adapters.each(&:not_found) if user.nil? || organization.nil?
    return adapters.each(&:unauthorized) if !user.can?(:create_network, organization)

    network = Network.new(request_model)
    return adapters.each(&:invalid) if !network.valid?

    network = NetworkRepository.new.create(network)
    return adapters.each(&:failed) if network.id.nil?

    adapters.each(&:succeeded)
  end
end
