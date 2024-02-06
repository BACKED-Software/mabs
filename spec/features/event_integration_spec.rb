# spec/features/event_integration_spec.rb

require 'rails_helper'

RSpec.describe 'Events Integration', type: :feature do
  before do
    Event.create(
      eventLocation: 'Sample Location',
      eventInfo: 'Sample Info',
      eventName: 'Sample Event',
      eventTime: DateTime.now,
    )
  end

  it 'displays the events index page' do
    visit events_path
    expect(page).to have_content('Sample Event')
    # Add more assertions as needed
  end

  it 'displays the event details page' do
    visit events_path
    click_link 'Sample Event'
    expect(page).to have_content('Sample Location')
    expect(page).to have_content('Sample Info')
    # Add more assertions as needed
  end

  it 'creates a new event with valid inputs' do
    sleep 1
    visit new_event_path
    fill_in 'event[eventLocation]', with: 'New Location'
    fill_in 'event[eventInfo]', with: 'New Info'
    fill_in 'event[eventName]', with: 'New Event'
    fill_in 'event[eventTime]', with: '2023-01-01 12:00:00'
    click_button 'Create Event'
    visit events_path
    expect(page).to have_content('New Event')
    # Add more assertions as needed
  end

  it 'fails to create a new event with missing location' do
    visit new_event_path
    fill_in 'event[eventInfo]', with: 'New Info'
    fill_in 'event[eventName]', with: 'New Event'
    fill_in 'event[eventTime]', with: '2023-01-01 12:00:00'
    click_button 'Create Event'
    expect(page).to have_content("Eventlocation can't be blank")
    # Add more assertions as needed
  end

  it 'fails to create a new event with missing info' do
    visit new_event_path
    fill_in 'event[eventLocation]', with: 'New Location'
    fill_in 'event[eventName]', with: 'New Event'
    fill_in 'event[eventTime]', with: '2023-01-01 12:00:00'
    click_button 'Create Event'
    expect(page).to have_content("Eventinfo can't be blank")
    # Add more assertions as needed
  end

  it 'fails to create a new event with missing name' do
    visit new_event_path
    fill_in 'event[eventLocation]', with: 'New Location'
    fill_in 'event[eventInfo]', with: 'New Info'
    fill_in 'event[eventTime]', with: '2023-01-01 12:00:00'
    click_button 'Create Event'
    expect(page).to have_content("Eventname can't be blank")
    # Add more assertions as needed
  end

  it 'fails to create a new event with missing time' do
    visit new_event_path
    fill_in 'event[eventLocation]', with: 'New Location'
    fill_in 'event[eventInfo]', with: 'New Info'
    fill_in 'event[eventName]', with: 'New Event'
    click_button 'Create Event'
    expect(page).to have_content("Eventtime can't be blank")
    # Add more assertions as needed
  end

  # Add more integration tests as needed
end