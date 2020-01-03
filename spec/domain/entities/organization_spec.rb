require_relative '../../../domain/entities/organization'

describe Organization do
  subject(:organization) { described_class.new(params) }

  let(:params) { { name: name } }
  let(:name) { 'Any non-nil value is valid' }

  describe 'validations' do
    describe 'name' do
      context 'when absent' do
        let(:name) { nil }

        it 'is not valid' do
          expect(organization.valid?).to be(false)
        end
      end

      context 'when present' do
        let(:name) { 'Name' }

        it 'is valid' do
          expect(organization.valid?).to be(true)
        end
      end
    end
  end
end