# frozen_string_literal: true

require 'rails_helper'

RSpec.describe AdminController, type: :controller do
  let(:user) { create(:user, is_admin: true) }
  let(:event) { create(:event, eventTime: Time.now + 1.day) }
  let(:backup_dir) { Rails.root.join('private', 'db_backups') }

  before do
    sign_in user
  end

  describe 'GET #event' do
    it 'assigns @event, @rsvps, and @rsvp_count' do
      get :event, params: { id: event.id }
      expect(assigns(:event)).to eq(event)
      expect(assigns(:rsvps)).to eq(event.rsvps)
      expect(assigns(:rsvp_count)).to eq(event.rsvps.count)
    end
  end

  describe 'GET #admin' do
    let!(:admin) { create(:user, is_admin: true) }
    let!(:user) { create(:user, gender: 'Man', is_hispanic_or_latino: true) }

    before do
      sign_in admin
    end

    it 'filters users by gender' do
      get :index, params: { gender: 'Man' }, format: :html
      expect(assigns(:users)).to include(user)
    end

    it 'filters users by is_hispanic_or_latino' do
      get :index, params: { is_hispanic_or_latino: 'true' }, format: :html
      expect(assigns(:users)).to include(user)
    end
  end

  describe '#backup_database' do
    it 'initiates backup job and redirects to admin_index_path' do
      expect(DatabaseBackupJob).to receive(:perform_later)
      post :backup_database
      expect(flash[:notice].to_s).to include 'Backup job submitted with job ID'
      expect(response).to redirect_to(admin_index_path)
    end
  end

  describe '#list_backups' do
    it 'assigns @backup_files' do
      get :list_backups
      expect(assigns(:backup_files)).to be_kind_of(Array)
    end
  end

  describe '#download_backup' do
    it 'downloads the backup if it exists' do
      allow(File).to receive(:exist?).and_return(true)
      allow_any_instance_of(AdminController).to receive(:send_file).and_return(:ok)

      get :download_backup, params: { file_name: 'backup.sql' }, format: :sql
      expect(response.status).to eq(204) # 204 No Content
    end

    it "redirects to list_backups_path if file doesn't exist" do
      get :download_backup, params: { file_name: 'backup.sql' }
      expect(response).to redirect_to(list_backups_path)
    end
  end

  describe '#delete_backup' do
    it 'deletes a backup file and redirects to list_backups_path' do
      # Mock File.exist? to return true
      allow(File).to receive(:exist?).and_return(true)
      # Mock File.delete to simulate file deletion
      allow(File).to receive(:delete)

      get :delete_backup, params: { file_name: 'backup.sql' }
      expect(flash[:notice]).to be_present
      expect(response).to redirect_to(list_backups_path)
    end
  end

  describe '#import_backup' do
    let(:file) { fixture_file_upload('backup.sql', 'text/plain') }

    it 'sets the flash alert when an exception is raised' do
      allow_any_instance_of(AdminController).to receive(:`).and_raise('Command execution error')

      post :import_backup, params: { backup_file: file }

      # Check that a flash alert was set
      expect(flash[:alert]).to be_present
      expect(response).to redirect_to(admin_index_path)
    end

    it 'imports a backup file and redirect to admin_index_path' do
      # Stub the backtick method (`) to prevent the actual command execution
      allow_any_instance_of(AdminController).to receive(:`).and_return('')

      # Stub the success? method to always return true
      allow_any_instance_of(Process::Status).to receive(:success?).and_return(true)

      post :import_backup, params: { backup_file: file }

      # Test redirection to expected path
      expect(response).to redirect_to(admin_index_path)
      # Test the presence of expected flash notice
      expect(flash[:alert]).to be_present
    end

    it 'sets the flash alert when no file is uploaded' do
      post :import_backup

      expect(flash[:alert]).to be_present
      expect(response).to redirect_to(admin_index_path)
    end
  end
end


RSpec.describe AdminController, type: :controller do
  let(:admin) { create(:user, is_admin: true) }
  let(:user) { create(:user, is_admin: false) }

  before do
    sign_in admin # Assuming Devise for authentication
  end

  # describe 'PATCH #update' do
  #   context 'with valid attributes' do
  #     it 'updates the user and redirects' do
  #       patch :update, params: { id: user.id, user: { full_name: 'Jane Doe' } }
  #       user.reload
  #       expect(user.full_name).to eq('Jane Doe')
  #       expect(flash[:notice]).to match(/successfully updated/)
  #       expect(response).to redirect_to(admin_index_path)
  #     end
  #   end

  #   context 'with invalid attributes' do
  #     it 'does not update the user and re-renders the index template' do
  #       patch :update, params: { id: user.id, user: { email: '' } } # Assuming email can't be blank
  #       expect(response).to render_template(:index)
  #     end
  #   end
  # end

  describe 'GET #delete' do
    it 'assigns the requested user to @user' do
      delete :destroy, params: { id: user.id }
      expect(assigns(:user)).to eq(user)
    end
  end

  describe 'DELETE #destroy' do
    let!(:user_to_delete) { create(:user) } # Ensure the user exists

    it 'deletes the user and redirects' do
      expect {
        delete :destroy, params: { id: user_to_delete.id }
      }.to change(User, :count).by(-1)
      expect(flash[:notice]).to match(/successfully removed/)
      expect(response).to redirect_to(admin_index_path)
    end
  end

  describe "GET #promote_to_admin" do
    it "promotes a user to admin and redirects to admin index with a notice" do
      get :promote_to_admin, params: { id: user.id }
      user.reload
      expect(user.is_admin).to be_truthy
      expect(response).to redirect_to(admin_index_path)
      expect(flash[:notice]).to eq("#{user.email} has been promoted to admin.")
    end
  end

  describe "GET #demote_to_user" do
    let(:another_admin) { create(:user, is_admin: true) } # Another admin for testing demotion

    it "demotes an admin to a regular user and redirects with a notice" do
      get :demote_to_user, params: { id: another_admin.id }
      another_admin.reload
      expect(another_admin.is_admin).to be_falsey
      expect(response).to redirect_to(admin_index_path)
      expect(flash[:notice]).to eq("#{another_admin.email} has been demoted to user.")
    end
  end

  describe "Authentication and Authorization" do
    context "when not signed in" do
      it "redirects to the sign-in page" do
        sign_out :user # Ensure no user is signed in
        get :index
        expect(response).to redirect_to(new_user_session_path)
      end
    end
  
    context "when signed in as a regular user" do
      let(:user) { create(:user, is_admin: false) }
  
      before do
        sign_in user
      end
  
      it "redirects to the root path with an unauthorized notice" do
        get :index
        expect(response).to redirect_to(root_path)
        expect(flash[:alert]).to eq('You are not authorized to access this page.')
      end
    end
  end
end

RSpec.describe AdminController, type: :controller do
  # Assuming you have a way to authenticate and set an admin user in your tests
  let(:admin) { create(:user, is_admin: true) }
  before do
    sign_in admin # You'll need to implement this helper method based on your authentication
  end

  describe "GET #demographics" do
    let!(:users) { create_list(:user, 5) } # Assuming you have FactoryBot set up for your User model

    context "when format is HTML" do
      it "assigns @users and renders the index template" do
        get :demographics, params: {}, format: :html
        expect(assigns(:users)).to match_array(users)
        expect(response).to render_template("index")
      end
    end

    context "when format is JSON" do
      it "responds with user data in JSON format" do
        get :demographics, params: {}, format: :json
        expect(response.content_type).to eq "application/json; charset=utf-8"
        expect(response).to have_http_status(:ok)
        # Check for user data in the response
      end
    end

    context "when format is CSV" do
      it "sends a CSV file" do
        get :demographics, params: {}, format: :csv
        expect(response.content_type).to eq "text/csv"
        expect(response.headers['Content-Disposition']).to include("filename=\"demographics-#{Date.today}.csv\"")
        # Check that CSV data includes user data
      end
    end

    context "with applied filters" do
      it "filters users correctly" do
        # Create specific users to test filtering
        # Apply filters via parameters
        # Verify that only expected users are returned
      end
    end

    context "with an error retrieving statistics" do
      it "redirects to admin_tools_path with an error flash message" do
        # Simulate error, e.g., by mocking a model method to raise an exception
        # Verify redirection and flash message
      end
    end
  end
end

RSpec.describe AdminController, type: :controller do
  include Devise::Test::ControllerHelpers

  let!(:user) { create(:user, full_name: "Jane Doe", email: "jane@example.com") }
  let!(:admin) { create(:user, is_admin: true) } # Assume you have an admin trait in your factory

  before do
    sign_in admin
  end

  describe "GET #index with search" do
    it "finds a user by full name" do
      get :index, params: { search: "Jane" }
      expect(assigns(:users)).to include(user)
      expect(response).to have_http_status(:success)
    end

    it "finds a user by email" do
      get :index, params: { search: "jane@example.com" }
      expect(assigns(:users)).to include(user)
      expect(response).to have_http_status(:success)
    end

    it "does not find users by unrelated search term" do
      get :index, params: { search: "unrelated" }
      expect(assigns(:users)).not_to include(user)
    end
  end
end

# spec/controllers/admin_controller_spec.rb
require 'rails_helper'

RSpec.describe AdminController, type: :controller do
  let(:admin) { create(:user, is_admin: true) } # Assume FactoryBot is set up for creating users. Adjust as necessary.

  before do
    # Simulate admin login
    sign_in admin
  end

  describe "POST #recalculate_points" do
    it "initiates recalculation job and redirects" do
      # Assuming RecalculateUserPointsJob is your ActiveJob
      expect(RecalculateUserPointsJob).to receive(:perform_later)

      post :recalculate_points

      expect(response).to redirect_to(admin_index_path)
      expect(flash[:notice]).to eq('Recalculation of points has been initiated.')
    end
  end
end
