# frozen_string_literal: true

# spec/features/attendances_spec.rb

require 'rails_helper'

RSpec.describe 'Attendances Integration', type: :feature do
  let!(:admin) { create(:admin) }
  let!(:user) { create(:user) }
  let!(:event) { create(:event, eventName: 'Test Event') }
  let!(:event2) { create(:event, eventName: 'Test Event 2', eventTime: Time.now + 1*60, password: 'pass') }
  let!(:attendance) { create(:attendance, eventID: event.id, googleUserID: user.uid) }
  before do
    Attendance.create(
      googleUserID: user.uid,
      eventID: event.id,
      pointsAwarded: event.eventPoints,
      timeOfCheckIn: DateTime.now
    )
  end
  context 'admin can' do
    before do
      sign_in admin
      visit attendances_path
    end

    it 'view all attended events' do
      expect(page).to have_content('Events Attended')
      expect(page).to have_content("Name: #{user.full_name}")
      expect(page).to have_content('Event Name: Test Event')
      expect(page).to have_content("Time: #{attendance.timeOfCheckIn}")
      expect(page).to have_content("Points: #{attendance.pointsAwarded}")
    end
  end
  context 'user can' do 
    before do
      sign_in user
      visit attendances_path
    end
    it 't access all attended events' do
      expect(page).to have_content('You are not authorized to access this page.')
    end

    it 'submit attendance form with incorrect password' do
      expect(page).to have_content('Enter Password:')
      fill_in 'password', with: 'psas'
      click_button 'Check In'

      expect(page).to have_content('Incorrect Password')
    end

    it 'submit attendance form with correct password to check in' do
      expect(page).to have_content('Enter Password:')
      fill_in 'password', with: 'pass'
      click_button 'Check In'

      expect(page).to have_content('You are Checked in')
    end

    it 'see event check in is not available yet' do
      click_button 'RSVP'
      expect(page).to have_content('Check in starts in')
    end
  end
end
