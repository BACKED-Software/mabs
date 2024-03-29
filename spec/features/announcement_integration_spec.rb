# frozen_string_literal: true

# spec/features/announcement_integration_spec.rb
require 'rails_helper'

RSpec.describe 'Announcements Integration', type: :feature do
  let!(:admin) { create(:admin) }
  let!(:user) { create(:user) }
  before do
    Announcement.create(
      googleUserID: admin.uid,
      subject: 'Example Subject',
      dateOfAnnouncement: DateTime.now,
      body: 'Example Body'
    )
  end
  context 'as an admin' do
    before do
      sign_in admin
    end

    it 'displays the announcements index page' do
      visit announcements_path
      expect(page).to have_content('Example Subject')
    end

    it 'displays the announcement details page' do
      visit announcements_path
      click_link 'Example Subject'
      expect(page).to have_content('Example Body')
    end

    it 'checks the presence of the Trix editor' do
      visit new_announcement_path
      expect(page).to have_css('trix-editor[id="announcement_body"]')
      expect(page).to have_selector("input[id='announcement_body_trix_input_announcement']", visible: false)
    end

    it 'updates an existing announcement' do
      # Create a new announcement to update
      announcement = Announcement.create(
        googleUserID: user.uid,
        subject: 'New Subject',
        dateOfAnnouncement: DateTime.now,
        body: 'New Body'
      )

      # Visit the show page of the announcement
      visit announcement_path(announcement)
      click_link 'Edit'
      fill_in 'announcement[subject]', with: 'Updated Subject'
      click_button 'Update Announcement'
      expect(page).to have_content('Updated Subject')
    end

    it 'fails to update an announcement' do
      # Create a new announcement to fail update
      announcement = Announcement.create(
        googleUserID: user.uid,
        subject: 'To Fail Update',
        dateOfAnnouncement: DateTime.now,
        body: 'Body to fail update'
      )

      visit announcements_path(announcement)
      click_link 'To Fail Update'
      click_link 'Edit'
      fill_in 'announcement[subject]', with: ''

      click_button 'Update Announcement'

      expect(page).to have_content("Subject can't be blank")
    end

    it 'fails to create a new announcement with missing body' do
      visit new_announcement_path
      fill_in 'announcement[subject]', with: 'New Subject'
      click_button 'Create Announcement'
      expect(page).to have_content("Body can't be blank")
    end
  end

  context 'as a user' do
    before do
      sign_in user
    end

    it 'displays the announcements index page' do
      visit announcements_path
      expect(page).to have_content('Example Subject')
    end

    it 'displays the announcement details page' do
      visit announcements_path
      click_link 'Example Subject'
      expect(page).to have_content('Example Body')
    end

    it 'create is not accessible' do
      visit new_announcement_path
      expect(page).to have_content('You are not authorized to access this page.')
    end

    it 'delete is not accessible' do
      # Create a new announcement to update
      announcement = Announcement.create(
        googleUserID: admin.uid,
        subject: 'Test event',
        dateOfAnnouncement: DateTime.now,
        body: 'New Body'
      )

      # Visit the show page of the announcement
      visit announcement_path(announcement)
      expect(page).not_to have_link('Delete')
    end
  end
end
