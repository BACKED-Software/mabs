# frozen_string_literal: true

# This class is for creating and storing MCABS announcements
class AnnouncementsController < ApplicationController
  before_action :set_announcement, only: %i[show edit update destroy]

  # GET /announcements or /announcements.json
  def index
    # Delete all rows
    # Announcement.delete_all
    # Reset the PK sequence
    # ActiveRecord::Base.connection.reset_pk_sequence!('announcements')

    @announcements = Announcement.all
  end

  # GET /announcements/1 or /announcements/1.json
  def show; end

  # GET /announcements/new
  def new
    @announcement = Announcement.new
  end

  # GET /announcements/1/edit
  def edit; end

  # POST /announcements or /announcements.json
  def create
    @announcement = Announcement.new(announcement_params)
    @announcement.dateOfAnnouncement = DateTime.now

    respond_to do |format|
      if @announcement.save
        format.html { redirect_to(announcements_path, notice: 'announcement was successfully created.') }
        format.json { render(:show, status: :created, location: @announcement) }
      else
        format.html { render(:new, status: :unprocessable_entity) }
        format.json { render(json: @announcement.errors, status: :unprocessable_entity) }
      end
    end
  end

  # PATCH/PUT /announcements/1 or /announcements/1.json
  def update
    respond_to do |format|
      if @announcement.update(announcement_params)
        format.html { redirect_to(announcements_path, notice: 'announcement was successfully updated.') }
        format.json { render(:show, status: :ok, location: @announcement) }
      else
        format.html { render(:edit, status: :unprocessable_entity) }
        format.json { render(json: @announcement.errors, status: :unprocessable_entity) }
      end
    end
  end

  def delete
    @announcement = Announcement.find(params[:id])
  end

  def destroy
    @announcement = Announcement.find(params[:id])
    @announcement.destroy!
    redirect_to(announcements_path, notice: 'announcement was successfully deleted.')
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_announcement
    @announcement = Announcement.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def announcement_params
    params.require(:announcement).permit(
      :announcementID,
      :googleUserID,
      :subject,
      :dateOfAnnouncement,
      :body
    )
  end
end
