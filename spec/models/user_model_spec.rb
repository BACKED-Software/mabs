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

    describe 'deleting a user' do
      it 'nullifies associated announcements' do
        user = create(:user)
        announcement = create(:announcement, googleUserID: user.uid)
        user.destroy
        expect(User.where(uid: user.uid)).to be_empty
        expect(Announcement.where(googleUserID: user.uid)).to be_empty
        expect(Announcement.find(announcement.id).googleUserID).to be_nil
      end
  
      it 'nullifies associated attendances' do
        user = create(:user)
        attendance = create(:attendance, googleUserID: user.uid)
        user.destroy
        expect(User.where(uid: user.uid)).to be_empty
        expect(Attendance.where(googleUserID: user.uid)).to be_empty
        expect(Attendance.find(attendance.id).googleUserID).to be_nil
      end
  
      it 'deletes associated points' do
        user = create(:user)
        create(:point, awardedTo: user.uid)
        user.destroy
        expect(User.where(uid: user.uid)).to be_empty
        expect(Point.where(awardedTo: user.uid)).to be_empty
      end
  
      it 'deletes associated rsvps' do
        user = create(:user)
        create(:rsvp, user_uid: user.uid)
        user.destroy
        expect(User.where(uid: user.uid)).to be_empty
        expect(Rsvp.where(user_uid: user.uid)).to be_empty
      end
  
      it 'handles all associations correctly when deleted' do
        user = create(:user)
        announcement = create(:announcement, googleUserID: user.uid)
        attendance = create(:attendance, googleUserID: user.uid)
        create(:point, awardedTo: user.uid)
        create(:rsvp, user_uid: user.uid)
        user.destroy
        expect(User.where(uid: user.uid)).to be_empty
        expect(Announcement.where(googleUserID: user.uid)).to be_empty
        expect(Announcement.find(announcement.id).googleUserID).to be_nil
        expect(Attendance.where(googleUserID: user.uid)).to be_empty
        expect(Attendance.find(attendance.id).googleUserID).to be_nil
        expect(Point.where(awardedTo: user.uid)).to be_empty
        expect(Rsvp.where(user_uid: user.uid)).to be_empty
      end
    end 
  end
end
