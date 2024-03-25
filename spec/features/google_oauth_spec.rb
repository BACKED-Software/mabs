# frozen_string_literal: true

require 'rails_helper'
require 'omniauth-google-oauth2'

RSpec.feature 'Google OAuth Authentication' do
  before do
    OmniAuth.config.test_mode = true
    OmniAuth.config.mock_auth[:google_oauth2] = OmniAuth::AuthHash.new({
           provider: 'google_oauth2',
           uid: '123545',
           info: {
             name: 'mockuser',
             email: 'mockuser@gmail.com'
           },
           credentials: {
             token: 'mock_token',
             expires_at: Time.now + 1.week
           },
         })
  end

  scenario 'User can log in using Google OAuth' do
    visit '/dashboard/index'
    click_link 'Sign In with Google'
    expect(page).to have_content 'mockuser'
  end
end