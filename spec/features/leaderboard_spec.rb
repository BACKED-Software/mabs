# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Leaderboard', type: :feature do
  let!(:user1) { create(:user, full_name: 'John Doe', total_points: 200) }
  let!(:user2) { create(:user, full_name: 'Jane Smith', total_points: 300) }
  let!(:user3) { create(:user, full_name: 'Bingus Schmingus', total_points: 100) }
  let!(:user4) { create(:user, full_name: 'Mario Mario', total_points: 5) }
  let!(:user5) { create(:user, full_name: 'Luigi Mario', total_points: 5) }
  let!(:user6) { create(:user, full_name: 'George Washington', total_points: 4) }
  let!(:user7) { create(:user, full_name: 'Abe Lincoln', total_points: 3) }
  let!(:user8) { create(:user, full_name: 'Clark Kent', total_points: 2) }
  let!(:user9) { create(:user, full_name: 'Bruce Wayne', total_points: 1) }
  let!(:user10) { create(:user, full_name: 'Jackie Brown', total_points: 0) }
  let!(:user11) { create(:user, full_name: 'User 11', total_points: 0) }
  let!(:user12) { create(:user, full_name: 'User 12', total_points: 0) }
  let!(:user13) { create(:user, full_name: 'User 13', total_points: 0) }
  let!(:user14) { create(:user, full_name: 'User 14', total_points: 0) }
  let!(:user15) { create(:user, full_name: 'User 15', total_points: 0) }

  before do
    login_as(user1, scope: :user)
  end

  it 'displays the user name' do
    visit leaderboard_index_path
    expect(page).to have_content(user1.full_name)
  end

  it 'displays the correct point total' do
    visit leaderboard_index_path
    expect(page).to have_content(user1.total_points.to_s)
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

  it 'displays the current user rank with appropriate medal icon' do
    original_stdout = $stdout
    original_stderr = $stderr
    $stdout = File.open(File::NULL, 'w')
    $stderr = File.open(File::NULL, 'w')

    visit leaderboard_index_path

    within('.current-user-rank') do
      expect(page).to have_css("h4.rank i.fas.fa-medal[style='color: goldenrod;']", count: 1) if @current_user_rank == 1
      expect(page).to have_css("h4.rank i.fas.fa-medal[style='color: silver;']", count: 1) if @current_user_rank == 2
      expect(page).to have_css("h4.rank i.fas.fa-medal[style='color: #CD7F32;']", count: 1) if @current_user_rank == 3
      expect(page).to have_content(@current_user_rank) # Make sure the rank number is present
    end
  ensure
    $stdout = original_stdout
    $stderr = original_stderr
  end

  it 'displays all users ranking trophies' do
    visit leaderboard_index_path
    click_link 'View All Users'
    expect(page).to have_css('i.fas.fa-medal', count: 3) # Make sure four medal icons are present (gold, silver, bronze)
    expect(page).to have_content('#', count: 13)
  end

  it 'gives tied users the same rank' do
    visit leaderboard_index_path
    click_link 'View All Users'
    expect(page).to have_content('# 4', count: 2)
  end

  it 'allows viewing all users' do
    visit leaderboard_index_path
    click_link 'View All Users'
    expect(page).to have_content(user1.full_name)
    expect(page).to have_content(user2.full_name)
    expect(page).to have_content(user3.full_name)
    expect(page).to have_content(user4.full_name)
  end

  it 'allows you to see top 5 users' do
    visit leaderboard_index_path
    expect(page).to have_content(user1.full_name, count: 2)
    expect(page).to have_content(user2.full_name)
    expect(page).to have_content(user3.full_name)
    expect(page).to have_content(user4.full_name)
    expect(page).to have_content(user5.full_name)
    expect(page).not_to have_content(user6.full_name)
    expect(page).not_to have_content(user7.full_name)
    expect(page).not_to have_content(user8.full_name)
    expect(page).not_to have_content(user9.full_name)
    expect(page).not_to have_content(user10.full_name)
  end

  it 'allows viewing more users' do
    visit leaderboard_index_path
    expect(page).to have_content(user1.full_name, count: 2)
    expect(page).to have_content(user2.full_name)
    expect(page).to have_content(user3.full_name)
    expect(page).to have_content(user4.full_name)
    expect(page).to have_content(user5.full_name)
    expect(page).not_to have_content(user6.full_name)
    expect(page).not_to have_content(user7.full_name)
    expect(page).not_to have_content(user8.full_name)
    expect(page).not_to have_content(user9.full_name)
    expect(page).not_to have_content(user10.full_name)
    expect(page).not_to have_content(user11.full_name)
    expect(page).not_to have_content(user12.full_name)
    expect(page).not_to have_content(user13.full_name)
    expect(page).not_to have_content(user14.full_name)
    expect(page).not_to have_content(user15.full_name)

    click_link 'View More Users'
    expect(page).to have_content(user1.full_name, count: 2)
    expect(page).to have_content(user2.full_name)
    expect(page).to have_content(user3.full_name)
    expect(page).to have_content(user4.full_name)
    expect(page).to have_content(user5.full_name)
    expect(page).to have_content(user6.full_name)
    expect(page).to have_content(user7.full_name)
    expect(page).to have_content(user8.full_name)
    expect(page).to have_content(user9.full_name)
    expect(page).to have_content(user10.full_name)
    expect(page).not_to have_content(user11.full_name)
    expect(page).not_to have_content(user12.full_name)
    expect(page).not_to have_content(user13.full_name)
    expect(page).not_to have_content(user14.full_name)
    expect(page).not_to have_content(user15.full_name)
  end
end
