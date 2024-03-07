# require 'rails_helper'

# RSpec.describe 'Admin views demographic statistics', type: :feature do
#   let!(:admin) { create(:user, is_admin: true) }

#   before do
#     sign_in admin
#     visit admin_demographics_path
#   end

#   it 'displays the demographic statistics section' do
#     expect(page).to have_content('Demographic Statistics')
#     expect(page).to have_css('canvas')
#   end
# end

# RSpec.describe "Non-Admin tries to view Demographic Statistics", type: :request do
#   let!(:non_admin) { create(:user, is_admin: false) }

#   it "blocks non-admin users" do
#     sign_in non_admin
#     get admin_demographics_path
#     expect(response).to redirect_to(root_path)
#   end

#   it "redirects unauthenticated users to sign-in page" do
#     get admin_demographics_path
#     expect(response).to redirect_to(new_user_session_path)
#   end
# end