# frozen_string_literal: true

class NotificationMailer < ApplicationMailer
  default to: -> { User.pluck(:email) },
          from: ENV['EMAIL_USERNAME'].presence || 'fallback@example.com'

  def new_announcement(announcement, host, port)
    @announcement = announcement
    @url = announcement_url(@announcement, host:, port:)
    mail(subject: "New MABS Announcement - #{@announcement.subject}")
  end

  def edit_announcement(announcement, host, port)
    @announcement = announcement
    @url = announcement_url(@announcement, host:, port:)
    mail(subject: "Update to MABS Announcement - #{@announcement.subject}")
  end
end
