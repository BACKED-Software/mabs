# frozen_string_literal: true

FactoryBot.define do
  factory :attendance do
    eventID { create(:event).id }
    googleUserID { create(:user).uid }
    timeOfCheckIn { Faker::Time.between(from: DateTime.now - 1, to: DateTime.now) }
    pointsAwarded { Faker::Number.between(from: 1, to: 10) }
  end
end
