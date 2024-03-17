require 'rails_helper'

RSpec.describe RecalculateUserPointsJob, type: :job do
  describe '#perform' do
    let(:user) { User.create!(uid: '123', email: 'test@tamu.edu', total_points: 0) }
    let(:event) do
      Event.create!(
        eventInfo: 'Information about the event',
        eventName: 'Event Name',
        eventTime: Time.current,  # Adjust if your app requires a specific time format
        eventLocation: 'Event Location'
      )
    end
    let!(:point) { Point.create!(awardedTo: user.uid, numPointsAwarded: 10, awardedBy: 'Admin', dateOfAward: Date.today) }
    let!(:attendance) { Attendance.create!(googleUserID: user.uid, pointsAwarded: 5, event: event) }

    it 'correctly recalculates the total points for a user' do
      # Trigger the job
      RecalculateUserPointsJob.perform_now

      # Reload the user to get the updated total_points
      user.reload

      # Check if the user's total points have been updated correctly
      expect(user.total_points).to eq(15)
    end
  end
end
