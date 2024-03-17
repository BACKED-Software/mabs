# frozen_string_literal: true

RSpec.describe User, type: :model do
  describe '.from_google' do
    context 'when creating a new user with Google OAuth' do
      let(:email) { 'user@tamu.edu' }
      let(:full_name) { 'John Doe' }
      let(:uid) { '123456' }
      let(:avatar_url) { 'http://example.com/avatar.png' }

      it 'initializes points to 0' do
        expect do
          User.from_google(email:, full_name:, uid:, avatar_url:)
        end.to change { User.count }.by(1)

        created_user = User.find_by(email:)
        expect(created_user).to be_present
        expect(created_user.total_points).to eq(0)
      end
    end
  end
end
