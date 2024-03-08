FactoryBot.define do
    factory :rsvp do
      sequence(:user_uid) { |n| "user_#{n}" }
      association :event
    end
  end
  