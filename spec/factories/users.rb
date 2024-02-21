# frozen_string_literal: true

FactoryBot.define do
  factory :user do
    email { Faker::Internet.email }
    uid { 123_456_789 }
    # Add any other attributes you need for your user model
  end
end
