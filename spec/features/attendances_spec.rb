# frozen_string_literal: true

# spec/features/attendances_spec.rb

require 'rails_helper'

RSpec.describe 'Attendances Integration', type: :feature do
  let!(:user) { create(:user) }
  let!(:event) { create(:event, eventName: 'Test Event') }
  let!(:event2) { create(:event, eventName: 'Test Event 2', eventTime: Time.now + 1 * 60, password: 'pass') }
  let!(:attendance) { create(:attendance, eventID: event.id, googleUserID: user.uid) }
  before do
    Attendance.create(
      googleUserID: user.uid,
      eventID: event.id,
      pointsAwarded: event.eventPoints,
      timeOfCheckIn: DateTime.now
    )
  end
  context 'user can' do
    before do
      sign_in user
      visit dashboard_index_path
    end

    it 'submit attendance form with incorrect password' do
      fill_in 'password', with: 'psas'
      click_button 'Check In'

      expect(page).to have_content('Incorrect Password')
    end

    it 'submit attendance form with correct password to check in' do
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
