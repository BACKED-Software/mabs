# frozen_string_literal: true

class Point < ApplicationRecord
  # Add validations to ensure that essential fields are present before saving to the database.
  validates :numPointsAwarded, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
  validates :awardedBy, presence: true
  validates :awardedTo, presence: true
  validates :dateOfAward, presence: true

  # It would be assumed that awardedTo is the email of the User who was awarded the points.
  # Considering that, awardedTo could belong_to user model.
  # If User model has email field and depending on your application details.
  belongs_to :user, primary_key: 'uid', foreign_key: 'awardedTo', optional: true
end
