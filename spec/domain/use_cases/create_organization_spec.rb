require_relative '../../../domain/use_cases/create_organization'

describe CreateOrganization do
  subject(:use_case) { described_class.new(user, organization, adapters) }

  let(:user) { instance_double(User, can?: authorized) }
  let(:authorized) { true }
  let(:organization) { instance_double(Organization, valid?: valid) }
  let(:valid) { true }
  let(:adapters) { [adapter1, adapter2] }
  let(:adapter1) { instance_double('adapter1') }
  let(:adapter2) { instance_double('adapter2') }

  describe '#perform' do
    subject(:perform) { use_case.perform }

    context 'when the user is unauthorized' do
      let(:authorized) { false }

      before do
        allow(adapter1).to receive(:unauthorized)
        allow(adapter2).to receive(:unauthorized)

        perform
      end

      it 'sends unauthorized message to adapters' do
        expect(adapter1).to have_received(:unauthorized)
        expect(adapter2).to have_received(:unauthorized)
      end
    end

    context 'when the user is authorized' do
      let(:authorized) { true }

      context 'and the organization is invalid' do
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

      context 'and the organization is valid' do
        let(:valid) { true }
        let(:organization_repository) { instance_double(OrganizationRepository) }
        let(:created_organization) { instance_double(Organization, id: organization_id) }

        before do
          allow(OrganizationRepository).to receive(:new).and_return(organization_repository)
          allow(organization_repository).to receive(:create).and_return(created_organization)
        end

        context 'and the repository fails to create the organization' do
          let(:organization_id) { nil }

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

        context 'and the repository successfully creates the organization' do
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
