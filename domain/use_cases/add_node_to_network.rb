require_relative '../repositories/node_repository'

class AddNodeToNetwork
  attr_reader :node, :actor, :context, :adapters

  def initialize(node:, actor:, context: nil, adapters: [])
    @node = node
    @actor = actor
    @context = context
    @adapters = Array(adapters)
  end

  def perform
    return adapters.each(&:unauthorized) unless actor.can?(:add_node_to_network, context)

    node.network_id = context.id
    return adapters.each(&:invalid) unless node.valid?

    updated_node = NodeRepository.new.update(node)
    return adapters.each(&:failed) unless updated_node.network_id == context.id

    adapters.each(&:succeeded)
  end
end
