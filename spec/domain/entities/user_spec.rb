require_relative '../../../domain/entities/user'

describe User do
  subject(:user) { described_class.new(params) }

  let(:params) { { name: name, email: email } }
  let(:name) { 'Any string is valid' }
  let(:email) { 'address@example.com' }

  describe 'validations' do
    describe 'name' do
      context 'when absent' do
        let(:name) { nil }

        it 'is not valid' do
          expect(user.valid?).to be(false)
        end
      end

      context 'when present' do
        let(:name) { 'Name' }

        it 'is valid' do
          expect(user.valid?).to be(true)
        end
      end
    end

    describe 'email' do
      context 'when absent' do
        let(:email) { nil }

        it 'is not valid' do
          expect(user.valid?).to be(false)
        end
      end

      context 'when present' do
        context 'and is not an email address' do
          let(:email) { 'Not an email address' }

          it 'is not valid' do
            expect(user.valid?).to be(false)
          end
        end

        context 'and is an email address' do
          let(:email) { 'email.address@example.com' }

          it 'is valid' do
            expect(user.valid?).to be(true)
          end
        end
      end
    end
  end
end