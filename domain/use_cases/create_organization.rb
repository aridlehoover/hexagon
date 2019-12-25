require_relative '../entities/user'
require_relative '../entities/organization'
require_relative '../repositories/user_repository'
require_relative '../repositories/organization_repository'

class CreateOrganization
  attr_reader :user_id, :request_model, :adapters

  def initialize(user_id, request_model, adapters = [])
    @user_id = user_id
    @request_model = request_model
    @adapters = Array(adapters)
  end

  def perform
    return adapters.each(&:invalid_argument) if user_id.nil?

    user = UserRepository.new.find(user_id)
    return adapters.each(&:not_found) if user.nil?
    return adapters.each(&:unauthorized) if !user.can?(:create_organization)

    organization = Organization.new(request_model)
    return adapters.each(&:invalid) if !organization.valid?

    organization = OrganizationRepository.new.create(organization)
    return adapters.each(&:failed) if organization.id.nil?

    adapters.each(&:succeeded)
  end
end
