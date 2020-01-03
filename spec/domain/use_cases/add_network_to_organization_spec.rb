require_relative '../../../domain/use_cases/add_network_to_organization'

describe AddNetworkToOrganization do
  subject(:use_case) { described_class.new(params) }

  let(:params) { { network: network, actor: actor, context: context, adapters: adapters } }
  let(:network) { Network.new }
  let(:valid) { true }
  let(:network_organization_id) { 123 }
  let(:actor) { instance_double(User, can?: authorized) }
  let(:authorized) { true }
  let(:context) { instance_double(Organization, id: organization_id) }
  let(:organization_id) { 234 }
  let(:adapters) { [adapter1, adapter2] }
  let(:adapter1) { instance_double('adapter1') }
  let(:adapter2) { instance_double('adapter2') }

  before do
    allow(network).to receive(:valid?).and_return(valid)
    allow(network).to receive(:organization_id).and_return(network_organization_id)
    allow(network).to receive(:organization_id=).and_call_original
  end

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
        let(:updated_network) { instance_double(Network, organization_id: updated_organization_id) }

        before do
          allow(NetworkRepository).to receive(:new).and_return(network_repository)
          allow(network_repository).to receive(:update).and_return(updated_network)
        end

        context 'and the repository fails to update the network' do
          let(:updated_organization_id) { 123 }
          let(:organization_id) { 234 }

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

        context 'and the repository successfully updates the network' do
          let(:updated_organization_id) { 42 }
          let(:organization_id) { 42 }

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
