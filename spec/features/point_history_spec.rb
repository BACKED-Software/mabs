RSpec.describe "Users combined history", type: :feature do
  before do
    @user = create(:user)
    sign_in @user
    @event = Event.create(
      eventLocation: 'Sample Location',
      eventInfo: 'Sample Info',
      eventName: 'Sample Event',
      eventTime: DateTime.now
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
      pointsAwarded: 5
    )
    visit root_path
  end

  it 'shows the correct badge and details for point records' do
    within('.pointHistoryModal') do
      expect(page).to have_css('.badge.text-bg-dark')
      expect(page).to have_content(@point.dateOfAward.strftime("%m/%d"))
      expect(page).to have_content(@point.awardDescription)
      expect(page).to have_content(@point.numPointsAwarded)
    end
  end

  it 'shows the correct badge and details for attendance records' do
    within('.pointHistoryModal') do
      expect(page).to have_css('.badge.bg-success')
      expect(page).to have_content(@attendance.timeOfCheckIn.in_time_zone.strftime("%m/%d"))
      expect(page).to have_content("Attendance to " + @event.eventName)
      expect(page).to have_content(@attendance.pointsAwarded)
    end
  end


end