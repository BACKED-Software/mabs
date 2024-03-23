require 'rails_helper'

RSpec.describe DatabaseBackupJob, type: :job do
  describe '#perform' do
    let(:logger) { instance_double('ActiveSupport::Logger') }
    let(:timestamp) { '20220203123456' }

    before do
      allow(Rails).to receive(:logger).and_return(logger)
      allow(logger).to receive(:info)
      allow(logger).to receive(:error)
      allow(Time).to receive_message_chain(:now, :utc, :strftime).and_return(timestamp)
    end

    it 'performs the database backup creation' do
      DatabaseBackupJob.perform_now

      expect(File.exist?(Rails.root.join('private', 'db_backups', "db_backup_#{timestamp}.sql"))).to be true
    end

    it 'logs an error message when an exception is raised' do
      allow_any_instance_of(DatabaseBackupJob).to receive(:execute_pg_dump).and_raise(StandardError.new('Command failed'))

      DatabaseBackupJob.perform_now

      expect(logger).to have_received(:error).with(a_string_starting_with('Failed to create backup:'))
    end
  end
end
