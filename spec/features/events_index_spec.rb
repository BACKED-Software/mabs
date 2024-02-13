require 'rails_helper'

RSpec.describe 'Events Index', type: :feature do
  before do
    # Update this section to include eventInfo
    Event.create!(eventName: 'Event 1', eventTime: 1.day.from_now, eventLocation: 'Location 1', eventPoints: 10, eventInfo: 'Info about Event 1')
    Event.create!(eventName: 'Event 2', eventTime: 2.days.from_now, eventLocation: 'Location 2', eventPoints: 20, eventInfo: 'Info about Event 2')
    Event.create!(eventName: 'Event 3', eventTime: 3.days.from_now, eventLocation: 'Location 3', eventPoints: 30, eventInfo: 'Info about Event 3')
  end

  it 'displays all events' do
    # Navigate to the dashboard page
    visit '/dashboard'

    # Loop through each event and assert that its details are displayed
    Event.all.each do |event|
      expect(page).to have_content(event.eventName)
      expect(page).to have_content(event.eventTime.strftime("%A, %B %-d"))
      expect(page).to have_content(event.eventLocation)
    end
  end
end
