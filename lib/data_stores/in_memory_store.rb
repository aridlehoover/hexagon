module DataStores
  class NotFoundError < StandardError; end

  class InMemoryStore
    attr_reader :klass

    def initialize(klass)
      @klass = klass

      unless self.class.instance_variables.include?(:@store)
        self.class.instance_variable_set(:@store, Hash.new { |hash, key| hash[key] = Hash.new })
      end

      unless store.keys.include?(:entities)
        store[:entities] = Array.new
      end

      unless store.keys.include?(:max_id)
        store[:max_id] = 0
      end
    end

    def clear
      entities.count.downto(1) { |i| entities.delete_at(i - 1) }
      reset_id_space
    end

    def find_all
      entities
    end

    def find(id)
      raise ArgumentError unless id.is_a?(Integer) && id > 0

      entities.find { |entity| entity.id == id }
    end

    def find_where(attributes)
      raise ArgumentError unless attributes.is_a?(Hash)

      entities.select do |entity|
        found = true
        attributes.each do |k, v|
          found = false unless entity.attributes[k] == v
          break unless found
        end
        found
      end
    end

    def create(attributes = {})
      raise ArgumentError unless attributes.is_a?(Hash)
      raise ArgumentError if attributes[:id]

      time = Time.now.utc

      entity = klass.new(
        {
          id: next_id,
          created_at: time,
          updated_at: time
        }.merge(attributes)
      )

      entities << entity
      entity
    end

    def update(attributes = {})
      raise ArgumentError unless attributes.is_a?(Hash)
      raise ArgumentError unless attributes[:id]

      entity = find(attributes[:id])
      raise NotFoundError if entity.nil?

      time = Time.now.utc

      attributes.each do |attribute, value|
        entity.send("#{attribute}=".to_sym, value)
      end

      entity.updated_at = time

      entity
    end

    def delete(id)
      id = id.id if id.is_a?(Entity)
      raise ArgumentError unless id.is_a?(Integer) && id > 0

      index = entities.find_index { |entity| entity.id = id }
      return nil if index.nil?

      entity = entities[index]
      entities.delete_at(index)
      entity
    end

    private

    def store
      self.class.instance_variable_get(:@store)[klass]
    end

    def entities
      store[:entities]
    end

    def max_id
      store[:max_id]
    end

    def next_id
      store[:max_id] += 1
    end

    def reset_id_space
      store[:max_id] = 0
    end
  end
end
