# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Removing a user', type: :feature do
  let!(:admin) { create(:admin) }
  # Ensure this matches your user factory
  let!(:user) do
    create(:user, full_name: 'John Doe', email: 'john@example.com')
  end
  context 'as an admin' do
    before do
      sign_in admin
      visit admin_tools_path
    end

    it 'successfully removes a user' do
      find('tr', text: 'John Doe').click_on('Remove User')
      expect(page).to have_css('#confirmationModal', visible: true)
      within '#confirmationModal' do
        expect(page).to have_content('Are you sure you want to proceed?', wait: 5)
        click_on('Confirm')
      end

      expect(page).not_to have_content('John Doe')
      expect(page).to have_content('john@example.com was successfully removed.')
    end
  end
end

# Promoting a user to admin
RSpec.describe 'Promoting a user to admin', type: :feature do
  let!(:admin) { create(:admin) }
  let!(:user) { create(:user, full_name: 'John Doe', email: 'john@example.com') }

  before do
    sign_in admin
    visit admin_tools_path
  end

  it 'successfully promotes a user' do
    find('tr', text: user.full_name).click_on('Promote to Admin')
    expect(page).to have_css('#confirmationModal', visible: true)
    within '#confirmationModal' do
      expect(page).to have_content('Are you sure you want to proceed?', wait: 5)
      click_on('Confirm')
    end

    expect(page).to have_content('john@example.com has been promoted to admin.', wait: 5)
  end
end

# Demote to User
RSpec.describe 'Demoting a user to admin', type: :feature do
  let!(:admin) { create(:admin) }
  let!(:user) { create(:user, full_name: 'John Doe', email: 'john@example.com', is_admin: true) }

  before do
    sign_in admin
    visit admin_tools_path
  end

  it 'successfully demotes a user' do
    find('tr', text: user.full_name).click_on('Demote to User')
    expect(page).to have_css('#confirmationModal', visible: true)
    within '#confirmationModal' do
      expect(page).to have_content('Are you sure you want to proceed?', wait: 5)
      click_on('Confirm')
    end

    expect(page).to have_content('john@example.com has been demoted to user.')
  end
end

RSpec.describe 'UserManagementActions', type: :request do
  let(:regular_user) { create(:user) }
  let(:admin_user) { create(:admin) }
  let(:target_user) { create(:user) }

  context 'when an unauthorized user attempts to demote an admin' do
    before { sign_in regular_user }

    it 'does not demote the admin and redirects' do
      expect do
        get demote_to_user_admin_path(target_user)
      end.not_to(change { target_user.reload.is_admin? })

      expect(response).to redirect_to(root_path) # Assuming unauthorized actions redirect to root
    end
  end

  # tests for promotion and removal actions
  context 'when an unauthorized user attempts to promote a user' do
    before { sign_in regular_user }

    it 'does not promote the user and redirects' do
      expect do
        get promote_to_admin_admin_path(target_user)
      end.not_to(change { target_user.reload.is_admin? })

      expect(response).to redirect_to(root_path) # Assuming unauthorized actions redirect to root
    end
  end

  context 'when an unauthorized user attempts to remove a user' do
    let!(:target_user) { create(:user) }

    before do
      sign_in regular_user
      # Ensure the setup does not inadvertently increase the user count beyond what's expected for the test
      create(:user) if User.count < 2
    end

    it 'does not remove a user and the count does not exceed 2' do
      # This assertion checks that the count does not change due to the operation
      expect do
        get destroy_user_path(target_user)
      end.not_to change(User, :count)

      # This assertion checks the count does not exceed 2 at any point
      expect(User.count).to be <= 2

      expect(response).to redirect_to(root_path)
    end
  end
end

RSpec.describe UsersController, type: :request do
  let(:user) { create(:user) } # Create a user from the factory

  describe 'PATCH #update_user_title' do
    context 'when updating the title of a user' do
      let(:new_title) { 'President' }

      before do
        patch update_user_title_path(user), params: { user: { title: new_title } }
      end

      it 'updates the user title successfully' do
        user.reload
        expect(user.title).to eq(new_title)
      end

      it 'redirects to the admin tools path with a success notice' do
        expect(response).to redirect_to(admin_tools_path)
        expect(flash[:notice]).to eq('User title updated successfully.')
      end
    end
  end
end

RSpec.describe 'Users', type: :request do
  let(:admin) { create(:user, is_admin: true) } # Create an admin user
  let(:user) { create(:user, title: 'Member') } # Create a user with default title

  describe 'PATCH update_user_title' do
    before do
      sign_in admin
      # visit admin_tools_path
    end

    let(:new_title) { 'President' } # New title to update the user with

    it "updates the user's title" do
      patch update_user_title_path(user), params: { user: { title: new_title } }
      user.save # Reload user from the database to get the updated title
      user.reload
      expect(user.title).to eq(new_title)
      expect(response).to redirect_to(admin_tools_path) # Or wherever you redirect to after update
      expect(flash[:notice]).to eq('User title updated successfully.')
    end
  end
end

# Create a test for update_user_title
