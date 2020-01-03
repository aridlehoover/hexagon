require_relative '../../../domain/use_cases/create_device'

describe CreateDevice do
  subject(:use_case) { described_class.new(params) }

  let(:params) { { device: device, actor: actor, context: context, adapters: adapters } }
  let(:device) { instance_double(Node, valid?: valid) }
  let(:valid) { true }
  let(:actor) { instance_double(User, can?: authorized) }
  let(:authorized) { true }
  let(:context) { instance_double(Network) }
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
        allow(Node).to receive(:new).and_return(device)
        allow(device).to receive(:valid?).and_return(valid)
      end

      context 'and the device is invalid' do
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

      context 'and the device is valid' do
        let(:valid) { true }
        let(:device_repository) { instance_double(NodeRepository) }
        let(:created_device) { instance_double(Node, id: device_id) }

        before do
          allow(NodeRepository).to receive(:new).and_return(device_repository)
          allow(device_repository).to receive(:create).and_return(created_device)
        end

        context 'and the repository fails to create the device' do
          let(:device_id) { nil }

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

        context 'and the repository successfully creates the device' do
          let(:device_id) { 42 }

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
