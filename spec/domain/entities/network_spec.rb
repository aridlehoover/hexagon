require_relative '../../../domain/entities/network'

describe Network do
  subject(:network) { described_class.new(params) }

  let(:params) { { name: name, type: type } }
  let(:name) { 'Any non-nil value is valid' }
  let(:type) { Network::TYPES.sample }

  describe 'validations' do
    describe 'name' do
      context 'when absent' do
        let(:name) { nil }

        it 'is not valid' do
          expect(network.valid?).to be(false)
        end
      end

      context 'when present' do
        let(:name) { 'Name' }

        it 'is valid' do
          expect(network.valid?).to be(true)
        end
      end
    end

    describe 'type' do
      context 'when absent and nil absent from list' do
        let(:type) { nil }

        it 'is not valid' do
          expect(network.valid?).to be(false)
        end
      end

      context 'when present' do
        context 'and not in allowed values' do
          let(:type) { :invalid_type }

          it 'is not valid' do
            expect(network.valid?).to be(false)
          end
        end

        context 'and in allowed values' do
          let(:type) { Network::TYPES.sample }

          it 'is valid' do
            expect(network.valid?).to be(true)
          end
        end
      end
    end
  end
end
