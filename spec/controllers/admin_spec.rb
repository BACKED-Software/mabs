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
