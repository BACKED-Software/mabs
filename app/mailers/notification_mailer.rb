# frozen_string_literal: true

class NotificationMailer < ApplicationMailer
  default to: -> { User.pluck(:email) },
    from: ENV['EMAIL_USERNAME']

  def new_announcement(announcement)
    @announcement = announcement
    @users = User.all

    mail(subject: "New MABS Announcement - #{@announcement.subject}")
  end

  def edit_announcement(announcement)
    @announcement = announcement
    @users = User.all

    mail(subject: "Update to MABS Announcement - #{@announcement.subject}")
  end
end
