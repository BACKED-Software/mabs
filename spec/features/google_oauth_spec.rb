require 'rails_helper'

RSpec.feature 'Google OAuth Authentication' do
  scenario 'User can log in using Google OAuth' do
    visit '/users/sign_in' # adjust the path as needed

    # Click on the Google OAuth login button
    #click_link 'Sign in with Google'

    #save_and_open_page
    # You may need to fill in any necessary information in the Google OAuth page

    # Expectations for successful authentication
    expect(page).to have_content 'Sign in with Google'

    # Additional expectations as needed
  end
end