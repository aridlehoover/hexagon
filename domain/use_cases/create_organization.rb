require_relative '../repositories/organization_repository'

class CreateOrganization
  attr_reader :user, :organization, :adapters

  def initialize(user, organization, adapters = [])
    @user = user
    @organization = organization
    @adapters = Array(adapters)
  end

  def perform
    return adapters.each(&:unauthorized) if !user.can?(:create_organization)
    return adapters.each(&:invalid) if !organization.valid?

    created_organization = OrganizationRepository.new.create(organization)
    return adapters.each(&:failed) if created_organization.id.nil?

    adapters.each(&:succeeded)
  end
end
