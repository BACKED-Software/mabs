# frozen_string_literal: true

# spec/features/points_award_manage_spec.rb

require 'rails_helper'

RSpec.describe 'PointsAwardManage', type: :feature do
  let!(:admin_user) { create(:user, is_admin: true) }
  let!(:other_user) { create(:user) }
  let!(:points) do
    create_list(:point, 1, numPointsAwarded: 5, awardDescription: 'words', awardedTo: other_user.uid, user: other_user)
  end

  before do
    login_as(admin_user, scope: :user)
  end

  scenario 'Admin user visits the points management page' do
    visit admin_tools_path
    expect(page).to have_content('Award User Points')
    expect(page).to have_content('Manage Awarded Points')
  end

  scenario 'Admin user awards points to a user' do
    visit admin_tools_path

    # Ensure the form is visible and expanded. Adjust the button text if necessary.
    click_on 'Award User Points' if has_button?('Award User Points')

    # You might need to scope this within the specific form or modal if necessary.
    within('#awardPointsForm') do
      fill_in 'User Identifier (Email or ID)', with: other_user.email
      fill_in 'point[numPointsAwarded]', with: 10
      fill_in 'point[dateOfAward]', with: Date.today
      fill_in 'point[awardDescription]', with: 'For excellent service'

      click_on 'Award Points'
    end

    expect(page).to have_content("Points successfully awarded to #{other_user.email}")
    expect(Point.last.awardDescription).to eq('For excellent service')
  end

  scenario 'Admin user manages points for a user' do
    visit admin_tools_path

    click_on 'Manage Awarded Points' if has_button?('Manage Awarded Points')

    within('#managePointsForm') do
      fill_in 'email', with: other_user.email
      click_on 'Manage Points'
    end

    expect(page).to have_content(other_user.email)

    # Assertions for each point's details
    points.each_with_index do |point, index|
      within("tr[data-point-id='#{point.id}']") do
        expect(find_field("points[#{index}][numPointsAwarded]").value).to eq point.numPointsAwarded.to_s
        expect(find_field("points[#{index}][awardedBy]").value).to eq point.awardedBy
        expect(find_field("points[#{index}][awardDescription]").value).to eq point.awardDescription
      end
    end
  end

  scenario 'Admin user deletes a point' do
    visit admin_tools_path

    click_on 'Manage Awarded Points'
    fill_in 'email', with: other_user.email
    click_on 'Manage Points'

    click_on 'Delete', match: :first

    expect(page).to have_content('Point was successfully deleted.')
  end
end
