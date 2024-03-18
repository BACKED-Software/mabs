# frozen_string_literal: true

FactoryBot.define do
  factory :point do
    numPointsAwarded { Faker::Number.between(from: 1, to: 10)}
    awardedBy { Faker::Internet.email }
    awardedTo { create(:user).uid }
    dateOfAward { Faker::Date.between(from: 2.days.ago, to: Date.today)}
    awardDescription { Faker::Lorem.sentence }
  end
end
