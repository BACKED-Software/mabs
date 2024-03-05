# spec/factories/events.rb
FactoryBot.define do
    factory :event do
      eventLocation { "Test Location" }
      eventInfo { "Test Info" }
      eventName { "Test Event" }
      eventTime { Time.now + 1.day }
      eventPoints { 10 }
      sponsor_title { "Test Sponsor" }
      sponsor_description { "Test Sponsor Description" }
    end
  end