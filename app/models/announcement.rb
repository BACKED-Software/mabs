# frozen_string_literal: true

class Announcement < ApplicationRecord
  self.primary_key = 'announcementID'
  validates :googleUserID, presence: true
  validates :subject, presence: true
  validates :dateOfAnnouncement, presence: true
  validates :body, presence: true
  belongs_to :user, foreign_key: 'googleUserID', optional: true
end
