require_relative '../../../lib/validations/validations'

class TestHarness
  include Validations

  validates :name
  validates :seasoning, list: [:plain, :salted]
  validates :type, regex: /(almond|cashew|pecan)/i

  attr_accessor :name, :seasoning, :type
end

describe Validations do
  subject(:test_harness) { TestHarness.new }

  before do
    test_harness.name = 'Cashew'
    test_harness.seasoning = :salted
    test_harness.type = 'Cashew'
  end

  describe 'presence' do
    context 'when absent' do
      before { test_harness.name = nil }

      it 'is not valid' do
        expect(test_harness.valid?).to be(false)
        expect(test_harness.errors).to include('name missing')
      end
    end

    context 'when present' do
      before { test_harness.name = 'Cashew' }

      it 'is valid' do
        expect(test_harness.valid?).to be(true)
        expect(test_harness.errors.count).to eq(0)
      end
    end
  end

  describe 'value from list' do
    context 'when absent and nil absent from list' do
      before { test_harness.seasoning = nil }

      it 'is not valid' do
        expect(test_harness.valid?).to be(false)
        expect(test_harness.errors).to include('seasoning not in [:plain, :salted]')
      end
    end

    context 'when present' do
      context 'and not in list' do
        before { test_harness.seasoning = :wasabi }

        it 'is not valid' do
          expect(test_harness.valid?).to be(false)
          expect(test_harness.errors).to include('seasoning not in [:plain, :salted]')
        end
      end

      context 'and in list' do
        before { test_harness.seasoning = :salted }

        it 'is valid' do
          expect(test_harness.valid?).to be(true)
          expect(test_harness.errors.count).to eq(0)
        end
      end
    end
  end

  describe 'regexp' do
    context 'when absent' do
      before { test_harness.type = nil }

      it 'is not valid' do
        expect(test_harness.valid?).to be(false)
        expect(test_harness.errors).to include('type does not match /(almond|cashew|pecan)/i')
      end
    end

    context 'when present' do
      context 'and not a match' do
        before { test_harness.type = 'peanut' }

        it 'is not valid' do
          expect(test_harness.valid?).to be(false)
          expect(test_harness.errors).to include('type does not match /(almond|cashew|pecan)/i')
        end
      end

      context 'and is a match' do
        before { test_harness.type = 'Cashew' }

        it 'is valid' do
          expect(test_harness.valid?).to be(true)
          expect(test_harness.errors.count).to eq(0)
        end
      end
    end
  end
end