# frozen_string_literal: true

require 'rails_helper'

RSpec.feature 'Admin views demographics', type: :feature do
  let!(:user) { create(:user, is_admin: true) }
  let!(:user1) { create(:user, gender: 'Man', is_hispanic_or_latino: false) }
  let!(:user2) { create(:user, gender: 'Woman', is_hispanic_or_latino: true) }

  before do
    sign_in user
    visit admin_demographics_path
  end

  scenario 'successfully views the demographics page' do
    expect(page).to have_content('Demographic Statistics')
  end

  scenario 'displays gender distribution chart' do
    select 'Gender Distribution', from: 'chart_type'
    expect(page).to have_content('Gender Distribution')
    # Verify presence of data related to the chart, if applicable.
  end

  scenario 'displays ethnicity distribution chart' do
    select 'Ethnicity Distribution (Hispanic or Latino)', from: 'chart_type'
    expect(page).to have_content('Ethnicity Distribution (Hispanic or Latino)')
  end

  scenario 'displays race distribution chart' do
    select 'Race Distribution', from: 'chart_type'
    expect(page).to have_content('Race Distribution')
  end

  scenario 'US Citizen distribution chart' do
    select 'US Citizen Distribution', from: 'chart_type'
    expect(page).to have_content('US Citizen Distribution')
  end

  scenario 'First Generation College Student distribution chart' do
    select 'First Generation College Student Distribution', from: 'chart_type'
    expect(page).to have_content('First Generation College Student Distribution')
  end

  scenario 'Classification distribution chart' do
    select 'Classification Distribution', from: 'chart_type'
    expect(page).to have_content('Classification Distribution')
  end
end

RSpec.describe 'Non-Admin tries to view Demographic Statistics', type: :request do
  let!(:non_admin) { create(:user, is_admin: false) }

  it 'blocks non-admin users' do
    sign_in non_admin
    get admin_demographics_path
    expect(response).to redirect_to(root_path)
  end

  it 'redirects unauthenticated users to sign-in page' do
    get admin_demographics_path
    expect(response).to redirect_to(new_user_session_path)
  end
end

RSpec.describe 'Admin exports Demographic Statistics', type: :request do
  let!(:admin) { create(:user, is_admin: true) }

  it 'exports to CSV' do
    sign_in admin
    get export_demographics_path
    expect(response.headers['Content-Type']).to eq('text/csv')
  end
end

RSpec.describe 'Admin deletes a user', type: :request do
  let!(:admin) { create(:user, is_admin: true) }
  let!(:user1) { create(:user) }

  it 'deletes a user' do
    sign_in admin
    get destroy_user_path(user1)
    expect(response).to redirect_to(admin_index_path)
    expect(User.exists?(user1.id)).to be_falsey
  end
end
