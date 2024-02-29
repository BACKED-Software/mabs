require 'rails_helper'

RSpec.describe 'Dashboard Integration', type: :feature do
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
end
