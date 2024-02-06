# spec/features/event_integration_spec.rb

require 'rails_helper'

RSpec.describe 'Events Integration', type: :feature do
  before do
    Event.create(
      eventLocation: 'Sample Location',
      eventInfo: 'Sample Info',
      eventName: 'Sample Event',
      eventTime: DateTime.now,
      sponsor: Sponsor.create(name: 'Sample Sponsor')
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
    visit new_event_path
    fill_in 'Event Location', with: 'New Location'
    fill_in 'Event Info', with: 'New Info'
    fill_in 'Event Name', with: 'New Event'
    fill_in 'Event Time', with: '2023-01-01 12:00:00'
    click_button 'Create Event'
    expect(page).to have_content('Event was successfully created.')
    # Add more assertions as needed
  end

  it 'fails to create a new event with missing location' do
    visit new_event_path
    fill_in 'Event Info', with: 'New Info'
    fill_in 'Event Name', with: 'New Event'
    fill_in 'Event Time', with: '2023-01-01 12:00:00'
    click_button 'Create Event'
    expect(page).to have_content("Location can't be blank")
    # Add more assertions as needed
  end

  it 'fails to create a new event with missing info' do
    visit new_event_path
    fill_in 'Event Location', with: 'New Location'
    fill_in 'Event Name', with: 'New Event'
    fill_in 'Event Time', with: '2023-01-01 12:00:00'
    click_button 'Create Event'
    expect(page).to have_content("Info can't be blank")
    # Add more assertions as needed
  end

  it 'fails to create a new event with missing name' do
    visit new_event_path
    fill_in 'Event Location', with: 'New Location'
    fill_in 'Event Info', with: 'New Info'
    fill_in 'Event Time', with: '2023-01-01 12:00:00'
    click_button 'Create Event'
    expect(page).to have_content("Name can't be blank")
    # Add more assertions as needed
  end

  it 'fails to create a new event with missing time' do
    visit new_event_path
    fill_in 'Event Location', with: 'New Location'
    fill_in 'Event Info', with: 'New Info'
    fill_in 'Event Name', with: 'New Event'
    click_button 'Create Event'
    expect(page).to have_content("Time can't be blank")
    # Add more assertions as needed
  end

  it 'fails to create a new event with invalid date/time format' do
    visit new_event_path
    fill_in 'Event Location', with: 'New Location'
    fill_in 'Event Info', with: 'New Info'
    fill_in 'Event Name', with: 'New Event'
    fill_in 'Event Time', with: 'Invalid Format'
    click_button 'Create Event'
    expect(page).to have_content('Time is not a valid datetime')
    # Add more assertions as needed
  end

  # Add more integration tests as needed
end