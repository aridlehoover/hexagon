require_relative '../../lib/entity'

class TestHarness < Entity
  attr_accessor :name
end

describe Entity do
  describe 'an invalid attribute given' do
    subject(:test_harness) { TestHarness.new(invalid_attribute: true) }

    it 'does not raise an error' do
      expect { test_harness }.not_to raise_error
    end
  end

  describe 'a valid attribute given' do
    subject(:test_harness) { TestHarness.new(name: 'Mickey Mouse')}

    it 'assigns attribute correctly' do
      expect(test_harness.name).to eq('Mickey Mouse')
    end
  end
end