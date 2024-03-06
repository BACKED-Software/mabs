# frozen_string_literal: true

# require 'rails_helper'

# RSpec.describe 'Admin dashboard', type: :feature do
#   let!(:admin) { create(:admin) }
#   let!(:user) { create(:user) }

#   before do
#     login_as(admin_user, scope: :admin)
#     visit admin_tools_path
#   end

#   it 'displays users' do
#     expect(page).to have_content(user.email)
#     expect(page).to have_content('User')
#   end

#   it 'allows admin to promote a user to admin' do
#     expect(page).to have_link('Promote to Admin', href: promote_to_admin_admin_path(user))
#     click_link('Promote to Admin', match: :first)
#     expect(page).to have_content("#{user.email} is now an admin.")
#     user.reload
#     expect(user.is_admin).to be_truthy
#   end

#   it 'allows admin to remove a user' do
#     expect(page).to have_link('Remove', href: remove_user_admin_path(user))
#     accept_confirm do
#       click_link('Remove', match: :first)
#     end
#     expect(page).to have_content("#{user.email} has been removed.")
#     expect { user.reload }.to raise_error ActiveRecord::RecordNotFound
#   end
# end

# spec/features/admin_dashboard_spec.rb
require 'rails_helper'

RSpec.describe 'Admin dashboard', type: :feature do
  let!(:admin) { create(:admin) }
  let!(:user) { create(:user) }

  context 'as an admin' do
    before do
      sign_in admin
      visit admin_tools_path
    end

    it 'displays users' do
      expect(page).to have_content(user.email)
      expect(page).to have_content('User')
    end

    # it 'allows admin to promote a user to admin' do
    #   within "#user_#{user.id}" do
    #     click_link 'Promote to Admin'
    #   end
    #   expect(page).to have_content('User is now an admin.')
    #   expect(user.reload.is_admin).to be_truthy
    # end

    # it 'allows admin to remove a user' do
    #   expect {
    #     within "#user_#{user.id}" do
    #       click_link 'Remove User'
    #     end
    #     expect(page).to have_content('User has been successfully removed.')
    #   }.to change(User, :count).by(-1)
    # end
  end

  context 'as a regular user' do
    before do
      sign_in user
      visit admin_tools_path
    end

    it 'does not allow access to admin dashboard' do
      expect(page).to have_content('You are not authorized to access this page.')
    end
  end
end
