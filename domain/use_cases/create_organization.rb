require_relative '../repositories/organization_repository'

class CreateOrganization
  attr_reader :organization, :actor, :context, :adapters

  def initialize(organization:, actor:, context: nil, adapters: [])
    @organization = organization
    @actor = actor
    @context = context
    @adapters = Array(adapters)
  end

  def perform
    return adapters.each(&:unauthorized) if !actor.can?(:create_organization, context)
    return adapters.each(&:invalid) if !organization.valid?

    created_organization = OrganizationRepository.new.create(organization)
    return adapters.each(&:failed) if created_organization.id.nil?

    adapters.each(&:succeeded)
  end
end
