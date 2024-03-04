# frozen_string_literal: true

class DashboardController < ApplicationController
  layout "authenticated_layout"

  def index
    @events = Event.all
    @announcements = Announcement.order(dateOfAnnouncement: :desc)
    @user = current_user
    # @most_recent_announcement = Announcement.order(dateOfAnnouncement: :desc).first

    # if @most_recent_announcement
    #   # Extracting specific attributes/columns
    #   @subject_announcement = @most_recent_announcement.subject
    #   @body_announcement = @most_recent_announcement.body
    #   @date_announcement = @most_recent_announcement.dateOfAnnouncement
    # else
    #   # Handle case where no announcements found
    #   @subject_announcement = "No announcements"
    #   @body_announcement = ""
    #   @date_announcement = "February 12, 2024"
    # end
  end
  
end
