class DatabaseBackupJob < ApplicationJob
  queue_as :default

  def perform(*args)
    backup_dir = Rails.root.join('private', 'db_backups')
    FileUtils.mkdir_p(backup_dir) unless Dir.exist?(backup_dir)

    timestamp = Time.now.utc.strftime('%Y%m%d%H%M%S')
    file_path = backup_dir.join("db_backup_#{timestamp}.sql")

    # Retrieve database configurations
    db_config = Rails.configuration.database_configuration[Rails.env]
    database = db_config["database"]
    username = ENV['DATABASE_USER'] || db_config["username"]
    password = ENV['DATABASE_PASSWORD']
    host = db_config["host"] || 'localhost'

    # Build the pg_dump command
    pg_dump_command = if password.present?
                        "PGPASSWORD='#{password}' pg_dump -U #{username} -h #{host} -Fc #{database} > #{file_path}"
                      else
                        "pg_dump -U #{username} -h #{host} -Fc #{database} > #{file_path}"
                      end

    # Execute the pg_dump command
    execute_pg_dump(pg_dump_command)
    Rails.logger.info "Backup created at #{file_path}"
  rescue => e
    Rails.logger.error "Failed to create backup: #{e.message}"
  end
  
  private

  def execute_pg_dump(command)
    system(command)
  end
end
