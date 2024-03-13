# frozen_string_literal: true

class DashboardController < ApplicationController
  layout 'authenticated_layout'

  def index
    @events = Event.all
    @announcements = Announcement.order(dateOfAnnouncement: :desc)
    @user = current_user
    if @user
      @total_points = @user.total_points
      @attendance_history ||= Attendance.where(googleUserID: @user.uid).order(created_at: :desc).order(created_at: :desc)
      @points_history ||= Point.where(awardedTo: @user.uid).order(created_at: :desc).order(dateOfAward: :desc)

      # Fetch and transform attendance records
      attendance_history = Attendance.where(googleUserID: @user.uid)
                                     .select('id, created_at as date, "pointsAwarded" as points, \'Attendance\' as type, "eventID"')
                                     .order(created_at: :desc)




      points_history = Point.where(awardedTo: @user.uid)
                            .select('"id", "dateOfAward" as date, "numPointsAwarded" as points, "awardDescription", \'Point\' as type')
                            .order(dateOfAward: :desc)


      # Combine, sort, and take the two most recent records
      @two_most_recent_records = (attendance_history + points_history)
                                   .sort_by { |record| record.date }
                                   .reverse
                                   .first(2)

      @combined_history = (attendance_history + points_history).sort_by(&:date).reverse

      Rails.logger.debug "Attendance History: #{attendance_history.inspect}"
      Rails.logger.debug "Points History: #{points_history.inspect}"

      Rails.logger.debug "@combined_history: #{@combined_history.inspect}"

    end

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
