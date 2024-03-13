# frozen_string_literal: true

# spec/features/attendances_spec.rb

require 'rails_helper'

RSpec.feature 'Attendances Integration', type: :feature do
  let(:user) { create(:user) }
  let(:existing_user) { User.find_by(uid: user.uid) }
  let!(:event) { create(:event, eventName: 'Test Event') }
  let!(:event2) { create(:event, eventName: 'Test Event 2') }
  let!(:attendance) { create(:attendance, eventID: event.id, googleUserID: user.uid) }
  before do
    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(user)
    Attendance.create(
      googleUserID: user.uid,
      eventID: event.id,
      pointsAwarded: event.eventPoints,
      timeOfCheckIn: DateTime.now,
    )
  end

  scenario 'user views attended events' do
    login_as(user, scope: :user)
    visit attendances_path

    expect(page).to have_content('Attendance Check In')
    expect(page).to have_link('Back to Home', href: '/dashboard/index')
    expect(page).to have_content('Events Attended')
    expect(page).to have_content("Name: #{user.full_name}")
    expect(page).to have_content('Event Name: Test Event')
    expect(page).to have_content("Time: #{attendance.timeOfCheckIn}")
    expect(page).to have_content("Points: #{attendance.pointsAwarded}")
    expect(page).to have_selector('form')
    expect(page).to have_select('event', with_options: ['Test Event'])
    expect(page).to have_button('Submit')
  end

  scenario 'user submits attendance form' do
    login_as(user, scope: :user)
    visit attendances_path

    select 'Test Event 2', from: 'event'
    click_button 'Submit'

    expect(page).to have_content('Attendance was successfully checked in.')
  end

  scenario 'User attempts to create a duplicate attendance record' do
    create(:attendance, event:, googleUserID: user.uid)

    sign_in user

    visit attendances_path

    select event.eventName, from: 'event'
    click_button 'Submit'

    expect(page).to have_content('You have already checked in for this event')
    expect(Attendance.count).to eq(3) # Ensure no new records were created
  end
end
