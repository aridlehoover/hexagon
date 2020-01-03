require_relative '../../../domain/entities/device'

describe Device do
  subject(:device) { described_class.new(params) }

  let(:params) do
    {
      name: name,
      type: type,
      mac_address: mac_address,
      ip_address: ip_address
    }
  end

  let(:name) { 'Any non-nil value is valid' }
  let(:type) { Node::TYPES.sample }
  let(:mac_address) { '01:02:03:04:05:06' }
  let(:ip_address) { '255.255.255.255' }

  describe 'validations' do
    describe 'name' do
      context 'when absent' do
        let(:name) { nil }

        it 'is not valid' do
          expect(device.valid?).to be(false)
        end
      end

      context 'when present' do
        let(:name) { 'Name' }

        it 'is valid' do
          expect(device.valid?).to be(true)
        end
      end
    end

    describe 'type' do
      context 'when absent and nil absent from list' do
        let(:type) { nil }

        it 'is not valid' do
          expect(device.valid?).to be(false)
        end
      end

      context 'when present' do
        context 'and not in allowed values' do
          let(:type) { :invalid_type }

          it 'is not valid' do
            expect(device.valid?).to be(false)
          end
        end

        context 'and in allowed values' do
          let(:type) { Node::TYPES.sample }

          it 'is valid' do
            expect(device.valid?).to be(true)
          end
        end
      end
    end

    describe 'mac_address' do
      context 'when absent' do
        let(:mac_address) { nil }

        it 'is not valid' do
          expect(device.valid?).to be(false)
        end
      end

      context 'when present' do
        context 'and is not a valid mac address' do
          let(:mac_address) { 'invalid' }

          it 'is invalid' do
            expect(device.valid?).to be(false)
          end
        end

        context 'and is a valid mac address' do
          let(:mac_address) { '01:23:45:67:89:ab' }

          it 'is valid' do
            expect(device.valid?).to be(true)
          end
        end
      end
    end

    describe 'ip_address' do
      context 'when absent' do
        let(:ip_address) { nil }

        it 'is not valid' do
          expect(device.valid?).to be(false)
        end
      end

      context 'when present' do
        context 'and is not an ip address' do
          let(:ip_address) { 'Not an ip address' }

          it 'is not valid' do
            expect(device.valid?).to be(false)
          end
        end

        context 'and is an ip address' do
          let(:ip_address) { '127.0.0.1' }

          it 'is valid' do
            expect(device.valid?).to be(true)
          end
        end
      end
    end
  end
end
