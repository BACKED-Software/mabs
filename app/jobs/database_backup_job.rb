class DatabaseBackupJob < ApplicationJob
  queue_as :default

  def perform(*_args)
    backup_dir = Rails.root.join('private', 'db_backups')
    FileUtils.mkdir_p(backup_dir) unless Dir.exist?(backup_dir)

    timestamp = Time.now.utc.strftime('%Y%m%d%H%M%S')
    file_path = backup_dir.join("db_backup_#{timestamp}.sql")

    unless ENV['DATABASE_URL']
      flash[:alert] = 'Database URL is not configured.'
      redirect_to admin_index_path and return
    end

    # Retrieve database configurations
    db_url = URI.parse(ENV['DATABASE_URL'])
    database_name = db_url.path.delete_prefix('/')
    username = db_url.user
    password = db_url.password
    host = db_url.host

    # Build the pg_dump command
    pg_dump_command = if password.present?
                        "PGPASSWORD='#{password}' pg_dump -U #{username} -h #{host} -Fc #{database_name} > #{file_path}"
                      else
                        "pg_dump -U #{username} -h #{host} -Fc #{database_name} > #{file_path}"
                      end

    # Execute the pg_dump command
    execute_pg_dump(pg_dump_command)
    Rails.logger.info "Backup created at #{file_path}"
  rescue StandardError => e
    Rails.logger.error "Failed to create backup: #{e.message}"
  end

  private

  def execute_pg_dump(command)
    system(command)
  end
end
