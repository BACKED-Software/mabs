# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Dashboard Integration', type: :feature do
  let!(:admin) { create(:admin) }
  let!(:user) { create(:user) }
  before do
    @user = create(:user)
    # Update this section to include eventInfo
    Event.create!(eventName: 'Event 1', eventTime: 1.day.from_now, eventLocation: 'Location 1',
                  eventInfo: 'Info about Event 1')
    Event.create!(eventName: 'Event 2', eventTime: 2.days.from_now, eventLocation: 'Location 2',
                  eventInfo: 'Info about Event 2')
    Event.create!(eventName: 'Event 3', eventTime: 3.days.from_now, eventLocation: 'Location 3',
                  eventInfo: 'Info about Event 3')
  end

  it 'displays all events' do
    # Navigate to the dashboard page
    visit '/'

    # Loop through each event and assert that its details are displayed
    Event.all.each do |event|
      expect(page).to have_content(event.eventName)
      expect(page).to have_content(event.eventTime.strftime('%A, %B %-d'))
      expect(page).to have_content(event.eventLocation)
    end
  end

  it 'displays message if no events are available' do
    # Delete all events
    Event.destroy_all
    visit '/'
    expect(page).to have_content('No Upcoming Events')
  end

  it 'displays message if no announcements are available' do
    Announcement.destroy_all
    visit '/'
    expect(page).to have_content('No Current Announcements')
  end

  it 'diplays the user name' do
    login_as(@user, scope: :user)
    visit '/'
    expect(page).to have_content(@user.full_name)
  end

  it 'has sign in button if signed out' do
    visit '/'
    expect(page).to have_content('Sign In')
  end

  it 'has sign out button if signed in' do
    login_as(@user, scope: :user)
    visit '/'
    expect(page).to have_content('Sign Out')
  end

  it 'has admin button if signed in as admin' do
    sign_in admin
    visit '/'
    expect(page).to have_content('Admin Tools')
  end

  it 'has no admin button if signed in as user' do
    sign_in user
    visit '/'
    expect(page).not_to have_content('Admin Tools')
  end

  it 'user cannot access admin tools directly' do
    sign_in user
    visit admin_tools_path
    expect(page).to have_content('You are not authorized to access this page.')
  end
end
