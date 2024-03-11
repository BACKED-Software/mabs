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

  scenario 'filters demographics by gender' do
    select 'Man', from: 'gender'
    click_button 'Filter'

    expect(page).to have_css('#gender-distribution-chart', visible: true)
    # Check for specific content or chart data reflecting the filter, depending on your implementation
  end

  scenario 'filters demographics by ethnicity' do
    select 'Yes', from: 'is_hispanic_or_latino'
    click_button 'Filter'

    expect(page).to have_css('#ethnicity-distribution-chart', visible: true)
    # Check for specific content or chart data reflecting the filter
  end
end

RSpec.describe "Non-Admin tries to view Demographic Statistics", type: :request do
    let!(:non_admin) { create(:user, is_admin: false) }
  
    it "blocks non-admin users" do
      sign_in non_admin
      get admin_demographics_path
      expect(response).to redirect_to(root_path)
    end
  
    it "redirects unauthenticated users to sign-in page" do
      get admin_demographics_path
      expect(response).to redirect_to(new_user_session_path)
    end
  end

RSpec.describe "Admin exports Demographic Statistics", type: :request do
  let!(:admin) { create(:user, is_admin: true) }

  it "exports to CSV" do
    sign_in admin
    get export_demographics_path
    expect(response.headers['Content-Type']).to eq('text/csv')
  end
end

# RSpec.describe "Admin deletes a user", type: :request do
#   let!(:admin) { create(:user, is_admin: true) }

#   it "deletes a user" do
#     sign_in admin
#     delete destroy_user_path(user)
#     expect(response).to redirect_to(admin_demographics_path)
#   end
# end