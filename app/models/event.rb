# frozen_string_literal: true

class Event < ApplicationRecord
  # will be added later after sponsor table is created
  # belongs_to :sponsor

  # Add any additional associations or validations here
  validates :eventInfo, presence: true
  validates :eventName, presence: true
  validates :eventTime, presence: true
  validates :eventLocation, presence: true
#   validates :sponsor_title
#   validates :sponsor_description
end
