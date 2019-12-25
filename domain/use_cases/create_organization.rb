require_relative '../repositories/organization_repository'

class CreateOrganization
  attr_reader :actor, :organization, :adapters

  def initialize(actor, organization, adapters = [])
    @actor = actor
    @organization = organization
    @adapters = Array(adapters)
  end

  def perform
    return adapters.each(&:unauthorized) if !actor.can?(:create_organization)
    return adapters.each(&:invalid) if !organization.valid?

    created_organization = OrganizationRepository.new.create(organization)
    return adapters.each(&:failed) if created_organization.id.nil?

    adapters.each(&:succeeded)
  end
end
