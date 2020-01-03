require_relative '../repositories/device_repository'

class CreateDevice
  attr_reader :device, :actor, :context, :adapters

  def initialize(device:, actor:, context: nil, adapters: [])
    @device = device
    @actor = actor
    @context = context
    @adapters = Array(adapters)
  end

  def perform
    return adapters.each(&:unauthorized) unless actor.can?(:create_device, context)
    return adapters.each(&:invalid) unless device.valid?

    created_device = NodeRepository.new.create(device)
    return adapters.each(&:failed) if created_device.id.nil?

    adapters.each(&:succeeded)
  end
end
