# frozen_string_literal: true

class Announcement < ApplicationRecord
  after_create :send_created_announcement_email
  after_update :send_updated_announcement_email

  self.primary_key = 'announcementID'
  has_rich_text :body
  validates :googleUserID, presence: true
  validates :subject, presence: true
  validates :dateOfAnnouncement, presence: true
  validates :body, presence: true
  belongs_to :user, foreign_key: 'googleUserID', optional: true

  def send_created_announcement_email
    NotificationMailer.new_announcement(self).deliver_later
  end

  def send_updated_announcement_email
    NotificationMailer.edit_announcement(self).deliver_later
  end
end
