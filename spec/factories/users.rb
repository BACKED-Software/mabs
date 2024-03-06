# frozen_string_literal: true

FactoryBot.define do
  factory :user do
    sequence(:uid) { |n| "uid#{n}" } # This will generate unique uid values like "uid1", "uid2", etc.
    email { Faker::Internet.email }
    full_name { Faker::Name.name }
    avatar_url { 'https://static.tvtropes.org/pmwiki/pub/images/Rickrolls.jpg' }
  end

  factory :admin, parent: :user do
    sequence(:uid) { |n| "admin#{n}" }
    email { Faker::Internet.email }
    full_name { Faker::Name.name }
    is_admin { true }
  end
end
