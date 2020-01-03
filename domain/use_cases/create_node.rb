require_relative '../repositories/node_repository'

class CreateNode
  attr_reader :node, :actor, :context, :adapters

  def initialize(node:, actor:, context: nil, adapters: [])
    @node = node
    @actor = actor
    @context = context
    @adapters = Array(adapters)
  end

  def perform
    return adapters.each(&:unauthorized) unless actor.can?(:create_node, context)
    return adapters.each(&:invalid) unless node.valid?

    created_node = NodeRepository.new.create(node)
    return adapters.each(&:failed) if created_node.id.nil?

    adapters.each(&:succeeded)
  end
end
