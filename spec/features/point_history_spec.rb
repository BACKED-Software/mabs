# frozen_string_literal: true

RSpec.describe 'Users combined history', type: :feature do
  before do
    @user2 = create(:user)
    @user = create(:user)
    sign_in @user
    @event = Event.create(
      eventLocation: 'Sample Location',
      eventInfo: 'Sample Info',
      eventName: 'Sample Event',
      eventTime: DateTime.tomorrow.change(hour: 8, min: 0, sec: 0),
      eventPoints: 10,
      sponsor_title: 'Sample Title',
      sponsor_description: 'Sample Description'
    )
    @point = Point.create(
      awardedBy: @user.uid,
      awardedTo: @user.uid,
      numPointsAwarded: 10,
      awardDescription: 'Test Point',
      dateOfAward: DateTime.now
    )
    @attendance = Attendance.create(
      googleUserID: @user.uid,
      eventID: @event.id,
      timeOfCheckIn: DateTime.now,
      pointsAwarded: 10
    )
    visit root_path
  end

  it 'shows the correct badge and details for point records' do
    within('.pointHistoryModal') do
      expect(page).to have_css('.badge.text-bg-dark')
      expect(page).to have_content(@point.dateOfAward.strftime('%m/%d'))
      expect(page).to have_content(@point.awardDescription)
      expect(page).to have_content(@point.numPointsAwarded)
    end
  end

  it 'shows the correct badge and details for attendance records' do
    within('.pointHistoryModal') do
      expect(page).to have_css('.badge.bg-success')
      expect(page).to have_content(@attendance.timeOfCheckIn.in_time_zone.strftime('%m/%d'))
      expect(page).to have_content("Attendance to #{@event.eventName}")
      expect(page).to have_content(@attendance.pointsAwarded)
    end
  end

  it 'shows a message if no history is available' do
    sign_out @user
    sign_in @user2
    visit root_path
    within('.pointHistoryModal') do
      expect(page).to have_content('No points history available')
    end
  end
end
