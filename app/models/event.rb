# frozen_string_literal: true

class Event < ApplicationRecord
  # will be added later after sponsor table is created
  # belongs_to :sponsor

  def start_time
    eventTime
  end

  # Add any additional associations or validations here
  validates :eventInfo, presence: true
  validates :eventName, presence: true
  validates :eventTime, presence: true
  validates :eventLocation, presence: true
  validate :event_time_in_future

  #   validates :sponsor_title
  #   validates :sponsor_description
  has_many :rsvps, foreign_key: 'event_id', dependent: :destroy
  has_many :attendances, foreign_key: 'eventID', dependent: :destroy

  private

  def event_time_in_future
    return unless eventTime.present? && eventTime < Time.now.in_time_zone

    errors.add(:eventTime, "can't be in the past")
  end
end
