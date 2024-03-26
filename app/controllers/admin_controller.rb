# frozen_string_literal: true

class AdminController < ApplicationController
  before_action :authenticate_user!  # Ensures the user is signed in
  before_action :check_admin         # Custom filter to check for admin status
  layout 'authenticated_layout'

  def valid_backup_file_name?(file_name)
    /\A\w[\w-]*\.sql\z/.match?(file_name)
  end

  def index
    @users = User.all
    @users = User.all.order(is_admin: :desc, full_name: :asc)
    if params[:search].present?
      search_term = "%#{params[:search]}%"
      @users = @users.where('full_name LIKE ? OR email LIKE ?', search_term, search_term)
    end
    @events = Event.all

    # prepare data for charts or tables here
    @gender_distribution = User.group(:gender).count.except(nil)
    @ethnicity_distribution = User.group(:is_hispanic_or_latino).count.except(nil).transform_keys do |key|
      key ? 'Yes' : 'No'
    end
    @race_distribution = User.group(:race).count.except(nil)
    @us_citizen_distribution = User.group(:is_us_citizen).count.except(nil).transform_keys { |key| key ? 'Yes' : 'No' }
    @first_generation_college_student_distribution = User.group(:is_first_generation_college_student).count.except(nil)
    @classification_distribution = User.group(:classification).count.except(nil)
  end

  def promote_to_admin
    user = User.find(params[:id])
    user.update!(is_admin: true)
    user.save
    flash[:notice] = "#{user.email} has been promoted to admin."
    redirect_to admin_index_path
  end

  def demote_to_user
    user = User.find(params[:id])
    user.update!(is_admin: false)
    user.save
    flash[:notice] = "#{user.email} has been demoted to user."
    redirect_to admin_index_path
  end

  def update
    @user = User.find(params[:id])
    if @user.update(user_params)
      flash[:notice] = '#{user.email} User was successfully updated.'
      redirect_to admin_index_path
    else
      render :index, status: :unprocessable_entity
    end
  end

  def delete
    @user = User.find(params[:id])
  end

  def destroy
    @user = User.find(params[:id])
    @user.destroy
    flash[:notice] = "#{@user.email} was successfully removed."
    redirect_to admin_index_path
  end

  def event
    @event = Event.find(params[:id])
    @rsvps = @event.rsvps
    @rsvp_count = @rsvps.count
  end

  def demographics
    @users = User.all
    apply_filters

    # prepare data for charts or tables here
    @gender_distribution = User.group(:gender).count.except(nil)
    @ethnicity_distribution = User.group(:is_hispanic_or_latino).count.except(nil).transform_keys do |key|
      key ? 'Yes' : 'No'
    end
    @race_distribution = User.group(:race).count.except(nil)
    @us_citizen_distribution = User.group(:is_us_citizen).count.except(nil).transform_keys { |key| key ? 'Yes' : 'No' }
    @first_generation_college_student_distribution = User.group(:is_first_generation_college_student).count.except(nil)
    @classification_distribution = User.group(:classification).count.except(nil)

    respond_to do |format|
      format.html # For the webpage
      format.json { render json: @users }
      format.csv { send_data @users.to_csv, filename: "demographics-#{Date.today}.csv" }
    rescue StandardError => e
      flash[:error] = "There was a problem retrieving statistics: #{e.message}"
      redirect_to admin_tools_path
    end
  end

  def export_demographics
    send_data User.to_csv, filename: "export-of-user-demographics-#{Date.today}.csv"
  end

  def recalculate_points
    RecalculateUserPointsJob.perform_later
    flash[:notice] = 'Recalculation of points has been initiated.'
    redirect_to admin_index_path
  end

  def backup_database
    job_id = DatabaseBackupJob.perform_later
    flash[:notice] = "Backup job submitted with job ID #{job_id}"
    redirect_to admin_index_path
  end

  def list_backups
    backup_dir = Rails.root.join('private', 'db_backups')
    @backup_files = Dir.glob("#{backup_dir}/*.sql").map do |file_path|
      {
        name: File.basename(file_path),
        size: File.size(file_path),
        created_at: File.ctime(file_path)
      }
    end
  end

  def download_backup
    file_name = params[:file_name]

    if valid_backup_file_name?(file_name)
      file_path = Rails.root.join('private', 'db_backups', file_name)

      if File.exist?(file_path)
        send_file file_path, type: 'application/sql', disposition: 'attachment', filename: file_name
      else
        redirect_to list_backups_path, alert: 'File not found.'
      end
    else
      redirect_to list_backups_path, alert: 'Invalid file name.'
    end
  end

  def delete_backup
    file_name = params[:file_name]

    if valid_backup_file_name?(file_name)
      backup_file_path = Rails.root.join('private', 'db_backups', file_name)

      if File.exist?(backup_file_path)
        File.delete(backup_file_path)
        flash[:notice] = "#{file_name} has been successfully deleted."
      else
        flash[:alert] = 'File not found.'
      end
    else
      flash[:alert] = 'Invalid file name.'
    end

    redirect_to list_backups_path
  end

  def import_backup
    uploaded_file = params[:backup_file]

    unless ENV['DATABASE_URL']
      flash[:alert] = "Database URL is not configured."
      redirect_to admin_index_path and return
    end

    if uploaded_file.present?
      # Generate a unique filename
      timestamp = Time.now.utc.strftime('%Y%m%d%H%M%S')
      file_name = "db_backup_#{timestamp}.sql"
      file_path = Rails.root.join('tmp', file_name)

      # Save the uploaded file to the server filesystem
      File.open(file_path, 'wb') do |file|
        file.write(uploaded_file.read)
      end

      Rails.logger.info "Importing database from file: #{file_path}"

      # Parse database URL from environment variables
      db_url = URI.parse(ENV['DATABASE_URL'])
      database_name = db_url.path.delete_prefix("/")
      username = db_url.user
      password = db_url.password
      host = db_url.host

      # Prepare environment variables for the command
      env = { 'PGPASSWORD' => password }

      # Build and execute the command using array syntax
      command = ['pg_restore', "--username=#{username}", "--dbname=#{database_name}", '--clean', "--host=#{host}",
                 file_path.to_s]
      Rails.logger.info "Executing command: #{command.join(' ')} without password for security reasons"

      success = system(env, *command)

      if success == true
        flash[:notice] = "Database successfully imported to #{database_name}."
      else
        flash[:alert] = "Import failed: #{e.message}"
      end

      # Remove the temporary file after import
      File.delete(file_path) if File.exist?(file_path)

    else
      flash[:alert] = 'No file uploaded.'
    end

    redirect_to admin_index_path
  rescue StandardError => e
    Rails.logger.error "Import failed: #{e.message}"
    flash[:alert] = "Import failed: #{e.message}"
    redirect_to admin_index_path
  end


  private

  def check_admin
    return if current_user&.admin?

    flash[:alert] = 'You are not authorized to access this page.'
    redirect_to root_path # or any other path you wish to redirect to
  end

  def apply_filters
    @users = @users.by_gender(params[:gender])
                   .by_race(params[:race])
                   .by_us_citizen(params[:is_us_citizen])
                   .by_first_generation_college_student(params[:is_first_generation_college_student])
                   .by_hispanic_or_latino(params[:is_hispanic_or_latino])
                   .by_classification(params[:classification])
    # Extend with additional filters as needed
  end
end
