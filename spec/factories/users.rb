# frozen_string_literal: true

FactoryBot.define do
  factory :user do
    email { Faker::Internet.email }
    uid { 123_456_789 }
    full_name { Faker::Name.name }
    avatar_url { 'https://static.tvtropes.org/pmwiki/pub/images/Rickrolls.jpg' }
    # Add any other attributes you need for your user model
  end
end
