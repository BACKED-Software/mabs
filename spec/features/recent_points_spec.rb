# frozen_string_literal: true

require 'rails_helper'

RSpec.describe "User's history", type: :feature do
  before do
    @user = create(:user)
    sign_in @user
    @event = Event.create(
      eventLocation: 'Sample Location',
      eventInfo: 'Sample Info',
      eventName: 'Sample Event',
      eventTime: DateTime.tomorrow.change(hour: 8, min: 0, sec: 0),
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
  end

  it 'shows the most recent point' do
    visit root_path
    expect(page).to have_content(@point.awardDescription)
    expect(page).to have_content(@point.numPointsAwarded)
  end

  it 'shows the most recent attendance' do
    visit root_path
    expect(page).to have_content(@attendance.created_at.strftime('%m/%d'))
    expect(page).to have_content("Attendance to #{@attendance.event.eventName}")
    expect(page).to have_content(@attendance.pointsAwarded)
  end

  context 'when there is no point history' do
    before do
      Point.delete_all
      visit root_path
    end

    it 'does not show any points' do
      expect(page).not_to have_content(@point.awardDescription)
    end
  end

  context 'when there is no attendance history' do
    before do
      Attendance.delete_all
      visit root_path
    end

    it 'does not show any attendances' do
      within('.pointHistory') do
        expect(page).not_to have_content(@attendance.event.eventName)
      end
    end
  end

  context 'when there are points but no attendance' do
    before do
      Attendance.delete_all
      visit root_path
    end

    it 'shows points but not attendances' do
      within('.pointHistory') do
        expect(page).to have_content(@point.awardDescription)
        expect(page).not_to have_content(@attendance.event.eventName)
      end
    end
  end

  context 'when there is attendance but no points' do
    before do
      Point.delete_all
      visit root_path
    end

    it 'shows attendances but not points' do
      within('.pointHistory') do
        expect(page).to have_content(@attendance.event.eventName)
        expect(page).not_to have_content(@point.awardDescription)
      end
    end
  end
end
