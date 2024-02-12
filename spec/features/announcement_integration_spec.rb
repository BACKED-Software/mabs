# spec/features/announcement_integration_spec.rb
require 'rails_helper'

RSpec.describe 'Announcements Integration', type: :feature do
  before do
    Announcement.create(
      googleUserID: 'example_user_id',
      subject: 'Example Subject',
      dateOfAnnouncement: DateTime.now,
      body: 'Example Body'
    )
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

  it 'creates a new announcement' do
    visit new_announcement_path
    fill_in 'announcement[googleUserID]', with: 'new_user_id'
    fill_in 'announcement[subject]', with: 'New Subject'
    fill_in 'announcement[body]', with: 'New Body'
    click_button 'Create Announcement'
    visit announcements_path
    expect(page).to have_content('New Subject')
  end

  it 'updates an existing announcement' do
    # Create a new announcement to update
    announcement = Announcement.create(
        googleUserID: 'new_user_id',
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

  it 'deletes an announcement' do
    # Create a new announcement to update
    announcement = Announcement.create(
        googleUserID: 'new_user_id',
        subject: 'New Subject',
        dateOfAnnouncement: DateTime.now,
        body: 'New Body'
    )

    # Visit the show page of the announcement
    visit announcement_path(announcement)
    click_link 'Delete'
    expect(page).not_to have_content('Example Subject')
  end
  
  it 'fails to create a new announcement with missing subject' do
    visit new_announcement_path
    fill_in 'announcement[googleUserID]', with: 'new_user_id'
    fill_in 'announcement[body]', with: 'New Body'
    click_button 'Create Announcement'
    expect(page).to have_content("Subject can't be blank")
  end

  it 'fails to create a new announcement with missing body' do
    visit new_announcement_path
    fill_in 'announcement[googleUserID]', with: 'new_user_id'
    fill_in 'announcement[subject]', with: 'New Subject'
    click_button 'Create Announcement'
    expect(page).to have_content("Body can't be blank")
  end
end
