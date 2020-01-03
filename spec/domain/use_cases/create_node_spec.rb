require_relative '../../../domain/use_cases/create_node'

describe CreateNode do
  subject(:use_case) { described_class.new(params) }

  let(:params) { { node: node, actor: actor, context: context, adapters: adapters } }
  let(:node) { instance_double(Node, valid?: valid) }
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
        allow(Node).to receive(:new).and_return(node)
        allow(node).to receive(:valid?).and_return(valid)
      end

      context 'and the node is invalid' do
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

      context 'and the node is valid' do
        let(:valid) { true }
        let(:node_repository) { instance_double(NodeRepository) }
        let(:created_node) { instance_double(Node, id: node_id) }

        before do
          allow(NodeRepository).to receive(:new).and_return(node_repository)
          allow(node_repository).to receive(:create).and_return(created_node)
        end

        context 'and the repository fails to create the node' do
          let(:node_id) { nil }

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

        context 'and the repository successfully creates the node' do
          let(:node_id) { 42 }

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
