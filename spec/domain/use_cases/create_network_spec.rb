require_relative '../../../domain/use_cases/create_network'

describe CreateNetwork do
  subject(:use_case) { described_class.new(actor, organization, network, adapters) }

  let(:actor) { instance_double(User, can?: authorized) }
  let(:authorized) { true }
  let(:organization) { instance_double(Organization) }
  let(:network) { instance_double(Network, valid?: valid) }
  let(:valid) { true }
  let(:adapters) { [adapter1, adapter2] }
  let(:adapter1) { instance_double('adapter1') }
  let(:adapter2) { instance_double('adapter2') }

  describe '#perform' do
    subject(:perform) { use_case.perform }

    context 'when the actor is unauthorized' do
      let(:authorized) { false }

      before do
        allow(adapter1).to receive(:unauthorized)
        allow(adapter2).to receive(:unauthorized)

        perform
      end

      it 'sends unauthorized' do
        expect(adapter1).to have_received(:unauthorized)
        expect(adapter2).to have_received(:unauthorized)
      end
    end

    context 'when the actor is authorized' do
      let(:authorized) { true }

      before do
        allow(Network).to receive(:new).and_return(network)
        allow(network).to receive(:valid?).and_return(valid)
      end

      context 'and the network is invalid' do
        let(:valid) { false }

        before do
          allow(adapter1).to receive(:invalid)
          allow(adapter2).to receive(:invalid)

          perform
        end

        it 'sends invalid' do
          expect(adapter1).to have_received(:invalid)
          expect(adapter2).to have_received(:invalid)
        end
      end

      context 'and the network is valid' do
        let(:valid) { true }
        let(:network_repository) { instance_double(NetworkRepository) }
        let(:created_network) { instance_double(Network, id: network_id) }

        before do
          allow(NetworkRepository).to receive(:new).and_return(network_repository)
          allow(network_repository).to receive(:create).and_return(created_network)
        end

        context 'and the repository fails to create the network' do
          let(:network_id) { nil }

          before do
            allow(adapter1).to receive(:failed)
            allow(adapter2).to receive(:failed)

            perform
          end

          it 'sends failed' do
            expect(adapter1).to have_received(:failed)
            expect(adapter2).to have_received(:failed)
          end
        end

        context 'and the repository successfully creates the network' do
          let(:network_id) { 42 }

          before do
            allow(adapter1).to receive(:succeeded)
            allow(adapter2).to receive(:succeeded)

            perform
          end

          it 'sends succeeded' do
            expect(adapter1).to have_received(:succeeded)
            expect(adapter2).to have_received(:succeeded)
          end
        end
      end
    end
  end
end
