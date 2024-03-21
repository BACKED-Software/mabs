# frozen_string_literal: true

# spec/factories/events.rb
FactoryBot.define do
  factory :event do
    eventLocation { Faker::Address.full_address }
    eventInfo { Faker::Lorem.paragraph }
    eventName { "#{Faker::Company.name} Event" }
    eventTime { Time.now + 1.day }
    eventPoints { Faker::Number.between(from: 1, to: 10) }
    sponsor_title { Faker::Company.name }
    sponsor_description { Faker::Lorem.paragraph }
  end
end
