# frozen_string_literal: true

class DashboardController < ApplicationController
  layout 'authenticated_layout'

  def index
    # Get all events that have an eventTime at least 4 hrs ago
    @events = Event.where(eventTime: Time.now - 4 * 60 * 60...).order(eventTime: :asc)
    @announcements = Announcement.order(dateOfAnnouncement: :desc).limit(2)
    @user = current_user
    return unless @user

    @total_points = @user.total_points
    # Fetch and transform attendance records
    attendance_history = Attendance.where(googleUserID: @user.uid)
                                   .select('id, created_at as date, "pointsAwarded" as points, \'Attendance\' as type, "eventID"')
                                   .order(created_at: :desc)

    points_history = Point.where(awardedTo: @user.uid)
                          .select('"id", "dateOfAward" as date, "numPointsAwarded" as points, "awardDescription", \'Point\' as type')
                          .order(dateOfAward: :desc)

    # Combine, sort, and take the two most recent records
    @two_most_recent_records = (attendance_history + points_history)
                               .sort_by(&:date)
                               .reverse
                               .first(2)

    @combined_history = (attendance_history + points_history).sort_by(&:date).reverse
  end
end
