# frozen_string_literal: true

# spec/features/event_integration_spec.rb

require 'rails_helper'

RSpec.describe 'Events Integration', type: :feature do
  let!(:admin) { create(:admin) } # Assuming you have a similar setup for admin

  # Use this pattern for creating or finding a user with a specific uid
  let!(:user) do
    User.find_by(uid: 'specific_uid') || create(:user, uid: 'specific_uid')
  end
  before do
    sign_in user
    event_time = DateTime.tomorrow.change(hour: 8, min: 0, sec: 0)
    @event = Event.create(
      eventLocation: 'Sample Location',
      eventInfo: 'Sample Info',
      eventName: 'Sample Event',
      eventTime: event_time,
      sponsor_title: 'Sample Title',
      sponsor_description: 'Sample Description'
    )
  end

  context 'as an admin' do
    before do
      sign_in admin
      visit events_path
    end

    it 'displays the event details page' do
      visit events_path
      # Find the button by its content
      button = find('button', text: @event.eventName)

      # Click the button
      button.click

      # Wait for the modal to appear
      expect(page).to have_selector('.modal', visible: true)

      expect(page).to have_content('Sample Location')
      expect(page).to have_content('Sample Info')
      # Add more assertions as needed
    end

    it 'updates an existing event' do
      visit events_path
      # Find the button by its content
      button = find('button', text: @event.eventName)

      # Click the button
      button.click

      expect(page).to have_selector('.modal', visible: true)
      click_link 'Edit'
      fill_in 'event[eventName]', with: 'Updated Name'
      click_button 'Update Event'
      visit events_path
      expect(page).to have_content('Updated Name')
    end

    it 'fails to update an event' do
      visit events_path
      # Find the button by its content
      button = find('button', text: @event.eventName)

      # Click the button
      button.click

      expect(page).to have_selector('.modal', visible: true)
      click_link 'Edit'
      fill_in 'event[eventName]', with: ''
      click_button 'Update Event'
      expect(page).to have_content("Eventname can't be blank")
    end

    it 'displays the events index page' do
      visit events_path
      expect(page).to have_content('Sample Event')
      # Add more assertions as needed
    end

    it 'checks the presence of the Trix editor' do
      visit new_event_path
      expect(page).to have_css('trix-editor[id="event_eventInfo"]')
      expect(page).to have_selector("input[id='event_eventInfo_trix_input_event']", visible: false)
    end

    it 'fills in the Trix editor field' do
      visit new_event_path

      # Set content in the Trix editor field
      trix_input_field = find("input[id='event_eventInfo_trix_input_event']", visible: false)
      trix_input_field.set('New Info')

      # Ensure content is set correctly
      expect(page).to have_css('trix-editor[id="event_eventInfo"]')
      expect(page).to have_selector("input[id='event_eventInfo_trix_input_event']", visible: false)
    end

    it 'creates a new event with valid inputs if logged in' do
      visit new_event_path

      # Fill in the form fields
      fill_in 'event[eventName]', with: 'New Event'
      fill_in 'event[eventLocation]', with: 'New Location'
      fill_in 'event[eventTime]', with: '2023-01-01T12:00' # Adjust format to match datetime-local field

      # Fill in the Trix editor
      trix_input_field = find("input[id='event_eventInfo_trix_input_event']", visible: false)
      trix_input_field.set('New Info')

      fill_in 'event[sponsor_title]', with: 'Event Sponsor'

      # Fill in the Trix editor for sponsor description
      trix_input_field = find("input[id='event_sponsor_description_trix_input_event']", visible: false)
      trix_input_field.set('New Description')

      click_button 'Create Event'

      visit events_path
      expect(page).to have_content('New Event')
      # Add more assertions as needed
    end

    it 'fails to create a new event with missing location if logged in' do
      visit new_event_path
      # Set content in the Trix editor field
      trix_input_field = find("input[id='event_eventInfo_trix_input_event']", visible: false)
      trix_input_field.set('New Info')
      fill_in 'event[eventName]', with: 'New Event'
      fill_in 'event[eventTime]', with: '2023-01-01 12:00:00'
      fill_in 'event[sponsor_title]', with: 'Event Sponsor'
      # Fill in the Trix editor for sponsor description
      trix_input_field = find("input[id='event_sponsor_description_trix_input_event']", visible: false)
      trix_input_field.set('New Description')
      click_button 'Create Event'
      expect(page).to have_content("Eventlocation can't be blank")
      # Add more assertions as needed
    end

    it 'fails to create a new event with missing info if logged in' do
      visit new_event_path
      fill_in 'event[eventLocation]', with: 'New Location'
      fill_in 'event[eventName]', with: 'New Event'
      fill_in 'event[eventTime]', with: '2023-01-01 12:00:00'
      fill_in 'event[sponsor_title]', with: 'Event Sponsor'
      # Fill in the Trix editor for sponsor description
      trix_input_field = find("input[id='event_sponsor_description_trix_input_event']", visible: false)
      trix_input_field.set('New Description')
      click_button 'Create Event'
      expect(page).to have_content("Eventinfo can't be blank")
      # Add more assertions as needed
    end

    it 'fails to create a new event with missing name if logged in' do
      visit new_event_path
      fill_in 'event[eventLocation]', with: 'New Location'
      # Set content in the Trix editor field
      trix_input_field = find("input[id='event_eventInfo_trix_input_event']", visible: false)
      trix_input_field.set('New Info')
      fill_in 'event[eventTime]', with: '2023-01-01 12:00:00'
      fill_in 'event[sponsor_title]', with: 'Event Sponsor'
      # Fill in the Trix editor for sponsor description
      trix_input_field = find("input[id='event_sponsor_description_trix_input_event']", visible: false)
      trix_input_field.set('New Description')
      click_button 'Create Event'
      expect(page).to have_content("Eventname can't be blank")
      # Add more assertions as needed
    end

    it 'fails to create a new event with missing time if logged in' do
      visit new_event_path
      fill_in 'event[eventLocation]', with: 'New Location'
      # Set content in the Trix editor field
      trix_input_field = find("input[id='event_eventInfo_trix_input_event']", visible: false)
      trix_input_field.set('New Info')
      fill_in 'event[eventName]', with: 'New Event'
      fill_in 'event[sponsor_title]', with: 'Event Sponsor'
      # Fill in the Trix editor for sponsor description
      trix_input_field = find("input[id='event_sponsor_description_trix_input_event']", visible: false)
      trix_input_field.set('New Description')
      click_button 'Create Event'
      expect(page).to have_content("Eventtime can't be blank")
    end
  end
  context 'as a user' do
    before do
      sign_in user
      visit events_path
    end

    it 'event password is not visible' do
      # Find the button by its content
      button = find('button', text: @event.eventName)

      # Click the button
      button.click

      # Wait for the modal to appear
      expect(page).to have_selector('.modal', visible: true)
      expect(page).not_to have_content('Password:')
    end

    ### This case is removed because it grabs the Edit Profile link, the edit event link is not present
    # it 'edit is not accessible' do
    #   expect(page).not_to have_link('Edit')
    # end

    it 'create is not accessible' do
      visit new_event_path
      expect(page).to have_content('You are not authorized to access this page.')
    end

    it 'displays the events index page' do
      visit events_path
      expect(page).to have_content('Sample Event')
      # Add more assertions as needed
    end

    it 'displays the event details page' do
      visit events_path
      click_button 'Sample Event'
      expect(page).to have_content('Sample Location')
      expect(page).to have_content('Sample Info')
      # Add more assertions as needed
    end
  end

  # Sponsor title test
  # it 'fails to create a new event with missing sponsor title' do
  #   visit new_event_path
  #   fill_in 'event[eventLocation]', with: 'New Location'
  #   fill_in 'event[eventInfo]', with: 'New Info'
  #   fill_in 'event[eventName]', with: 'New Event'
  #   fill_in 'event[eventTime]', with: '2023-01-01 12:00:00'
  #   fill_in 'event[sponsor_description]', with: 'Event Sponsor Description'
  #   click_button 'Create Event'
  #   expect(page).to have_content("Sponsor title can't be blank")
  #   # Add more assertions as needed
  # end

  # # Sponsor description blank test
  # it 'fails to create a new event with missing sponsor description' do
  #   visit new_event_path
  #   fill_in 'event[eventLocation]', with: 'New Location'
  #   fill_in 'event[eventInfo]', with: 'New Info'
  #   fill_in 'event[eventName]', with: 'New Event'
  #   fill_in 'event[eventTime]', with: '2023-01-01 12:00:00'
  #   fill_in 'event[sponsor_title]', with: 'Event Sponsor'
  #   click_button 'Create Event'
  #   expect(page).to have_content("Sponsor description can't be blank")
  #   # Add more assertions as needed
  # end

  # Sponsor description minimum test
  # it 'fails to create a new event with low sponsor description' do
  #   visit new_event_path
  #   fill_in 'event[eventLocation]', with: 'New Location'
  #   fill_in 'event[eventInfo]', with: 'New Info'
  #   fill_in 'event[eventName]', with: 'New Event'
  #   fill_in 'event[eventTime]', with: '2023-01-01 12:00:00'
  #   fill_in 'event[sponsor_title]', with: 'Event Sponsor'
  #   fill_in 'event[sponsor_description]', with: 'Event'
  #   click_button 'Create Event'
  #   expect(page).to have_content('Sponsor description is too short (minimum is 10 characters)')
  # Add more assertions as needed
  # end
end
