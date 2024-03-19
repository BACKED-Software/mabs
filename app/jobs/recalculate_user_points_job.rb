# frozen_string_literal: true

class RecalculateUserPointsJob < ApplicationJob
  queue_as :default

  def perform(*_args)
    User.find_each do |user|
      # Calculate points from the Point model
      points_from_points = user.points.sum(:numPointsAwarded)

      # Log the points calculated from the Point model
      Rails.logger.info "User #{user.uid} - Points from points: #{points_from_points}"

      # Calculate points from the Attendance model explicitly using googleUserID
      points_from_attendances = Attendance.where(googleUserID: user.uid).sum(:pointsAwarded)

      # Log the points calculated from the Attendance model
      # Rails.logger.info "User #{user.uid} - Points from attendances: #{points_from_attendances}"

      # Sum both
      total_points = points_from_points + points_from_attendances

      # Log the total points before updating
      # Rails.logger.info "User #{user.uid} - Total points to be updated: #{total_points}"

      # Update the user's total points
      user.update(total_points:)
    end
  end
end
