# frozen_string_literal: true

# spec/features/attendances_spec.rb

require 'rails_helper'

RSpec.feature 'Attendances Integration', type: :feature do
  let(:user) { create(:user) }
  let(:event) { create(:event) }

  scenario 'User attempts to create a duplicate attendance record' do
    create(:attendance, event:, googleUserID: user.uid)

    sign_in user

    visit attendances_path

    select event.eventName, from: 'event'
    click_button 'Submit'

    expect(page).to have_content('You have already checked in for this event')
    expect(Attendance.count).to eq(1) # Ensure no new records were created
  end
end
