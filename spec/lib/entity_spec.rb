# frozen_string_literal: true

require_relative '../../lib/entity'

describe Entity do
  let(:test_harness_class) { Class.new(Entity) { attr_accessor :name } }

  describe 'an invalid attribute given' do
    subject(:test_harness) { test_harness_class.new(invalid_attribute: true) }

    it 'does not raise an error' do
      expect { test_harness }.not_to raise_error
    end
  end

  describe 'a valid attribute given' do
    subject(:test_harness) { test_harness_class.new(name: 'Mickey Mouse') }

    it 'assigns attribute correctly' do
      expect(test_harness.name).to eq('Mickey Mouse')
    end
  end

  describe '#attributes' do
    subject(:attributes) { test_harness.attributes }

    context 'when some attributes are not provided' do
      let(:test_harness_class) { Class.new(Entity) { attr_accessor :name, :species } }
      let(:test_harness) { test_harness_class.new(name: 'Donald Duck') }

      it 'returns all assigned and unassigned attributes' do
        expect(attributes).to eq(name: 'Donald Duck', species: nil)
      end
    end

    context 'when the entity has private instance variables' do
      let(:test_harness_class) do
        Class.new(Entity) do
          attr_accessor :name

          def do_something
            @private_instance_variable = 'keep track of something'
          end
        end
      end

      let(:test_harness) { test_harness_class.new(name: 'Goofy') }

      before { test_harness.do_something }

      it 'does not return private instance variables' do
        expect(attributes).to eq(name: 'Goofy')
      end
    end
  end
end
