require_relative '../../../domain/use_cases/create_organization'

describe CreateOrganization do
  subject(:use_case) { described_class.new(user_id, params, adapters) }

  let(:user_id) { 42 }
  let(:params) { {} }
  let(:adapters) { [adapter1, adapter2] }
  let(:adapter1) { instance_double('adapter1') }
  let(:adapter2) { instance_double('adapter2') }

  describe '#perform' do
    subject(:perform) { use_case.perform }

    context 'when the user_id is absent' do
      let(:user_id) { nil }

      before do
        allow(adapter1).to receive(:invalid_argument)
        allow(adapter2).to receive(:invalid_argument)

        perform
      end

      it 'sends invalid argument' do
        expect(adapter1).to have_received(:invalid_argument)
        expect(adapter2).to have_received(:invalid_argument)
      end
    end

    context 'when the user_id is present' do
      let(:user_id) { 42 }
      let(:user_repository) { instance_double(UserRepository) }

      before do
        allow(UserRepository).to receive(:new).and_return(user_repository)
        allow(user_repository).to receive(:find).and_return(user)
      end

      context 'and the user is not found' do
        let(:user) { nil }

        before do
          allow(adapter1).to receive(:not_found)
          allow(adapter2).to receive(:not_found)

          perform
        end

        it 'sends not found' do
          expect(adapter1).to have_received(:not_found)
          expect(adapter2).to have_received(:not_found)
        end
      end

      context 'and the user is found' do
        let(:user) { instance_double(User) }

        before do
          allow(user).to receive(:can?).and_return(authorized)
        end

        context 'and they are not authorized' do
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

        context 'and they are authorized' do
          let(:authorized) { true }
          let(:organization) { instance_double(Organization) }

          before do
            allow(Organization).to receive(:new).and_return(organization)
            allow(organization).to receive(:valid?).and_return(valid)
          end

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
            let(:organization_id) { nil }

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
              let(:organization_id) { 123 }

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
  end
end