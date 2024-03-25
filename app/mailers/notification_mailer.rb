# frozen_string_literal: true

class NotificationMailer < ApplicationMailer
  def new_announcement(announcement)
    @announcement = announcement
    @users = User.all

    @users.each do |user|
      mail(to: user.email, from: ENV['EMAIL_USERNAME'], subject: "New MABS Announcement - #{@announcement.subject}")
    end
  end

  def edit_announcement(announcement)
    @announcement = announcement
    @users = User.all

    @users.each do |user|
      mail(to: user.email, from: ENV['EMAIL_USERNAME'],
           subject: "Update to MABS Announcement - #{@announcement.subject}")
    end
  end
end
