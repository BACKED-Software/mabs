# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Leaderboard', type: :feature do
  let!(:user1) { create(:user, full_name: 'John Doe', total_points: 100) }
  let!(:user2) { create(:user, full_name: 'Jane Smith', total_points: 200) }
  let!(:user3) { create(:user, full_name: 'Bingus Schmingus', total_points: 10) }
  let!(:user4) { create(:user, full_name: 'Mario Mario', total_points: 0) }
  let!(:user5) { create(:user, full_name: 'Luigi Mario', total_points: 0) }

  before do
    login_as(user1, scope: :user)
  end

  it 'displays the user name' do
    visit leaderboard_index_path
    expect(page).to have_content(user1.full_name)
  end

  it 'displays the correct point total' do
    visit leaderboard_index_path
    expect(page).to have_content("#{user1.total_points} points")
  end

  it 'displays points in descending order' do
    visit leaderboard_index_path
    click_link 'View All Users'

    # Find the index where "Top Users" section starts
    top_users_index = page.body.index('Top Users')
    # Get the text after "Top Users" section
    users_after_top_users = page.body[top_users_index..]

    # Check if user2's name appears before user1's name in the "Top Users" section
    expect(users_after_top_users).to match(/#{user2.full_name}.*#{user1.full_name}/m)
  end

  it 'displays the current_user rank' do
    visit leaderboard_index_path
    expect(page).to have_content('Your Ranking: 2', count: 1)
  end

  it 'displays all users rankings' do
    visit leaderboard_index_path
    click_link 'View All Users'
    expect(page).to have_content('#1', count: 1)
    expect(page).to have_content('#2', count: 1)
    expect(page).to have_content('#3', count: 1)
    expect(page).to have_content('#4', count: 2)
  end

  it 'gives tied users the same rank' do
    visit leaderboard_index_path
    click_link 'View All Users'
    expect(page).to have_content('#4', count: 2)
  end

  it 'allows viewing all users' do
    visit leaderboard_index_path
    click_link 'View All Users'
    expect(page).to have_content(user1.full_name)
    expect(page).to have_content(user2.full_name)
    expect(page).to have_content(user3.full_name)
    expect(page).to have_content(user4.full_name)
  end

  it 'allows viewing next users' do
    visit leaderboard_index_path
    expect(page).to have_content(user1.full_name, count: 2) # Will find twice since user name is also in off-canvas for profile, user1 is displayed by default since they are logged in
    expect(page).to have_content(user2.full_name) # user2 has most points
    expect(page).not_to have_content(user3.full_name)
    expect(page).not_to have_content(user4.full_name)

    click_link 'View Next Users'
    expect(page).to have_content(user1.full_name, count: 2) # user1 should appear twice now
    expect(page).to have_content(user2.full_name)
    expect(page).not_to have_content(user3.full_name)
    expect(page).not_to have_content(user4.full_name)

    click_link 'View Next Users'
    expect(page).to have_content(user1.full_name, count: 2)
    expect(page).to have_content(user2.full_name)
    expect(page).to have_content(user3.full_name)
    expect(page).not_to have_content(user4.full_name)
  end
end
