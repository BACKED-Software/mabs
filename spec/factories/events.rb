# frozen_string_literal: true

# spec/factories/events.rb
FactoryBot.define do
  factory :event do
    eventLocation { Faker::Address.full_address }
    eventInfo { Faker::Lorem.paragraph }
    eventTime { 1.day.from_now } # More idiomatic way for future time
    eventPoints { Faker::Number.between(from: 1, to: 10) }
    sponsor_title { Faker::Company.name }
    sponsor_description { Faker::Lorem.paragraph }

    # Using a sequence for eventName to ensure uniqueness if required
    sequence(:eventName) { |n| "#{Faker::Company.name} Event #{n}" }

    # Allows overriding eventTime when creating an event if specific timing is needed
    transient do
      custom_event_time { nil }
    end

    after(:build) do |event, evaluator|
      event.eventTime = evaluator.custom_event_time unless evaluator.custom_event_time.nil?
    end
  end
end
